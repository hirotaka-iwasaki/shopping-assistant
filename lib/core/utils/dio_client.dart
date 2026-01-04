import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'exceptions.dart';
import 'logger.dart';

/// Factory for creating configured Dio instances.
class DioClient {
  DioClient._();

  /// Creates a Dio instance with common configuration.
  static Dio create({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? ApiConfig.connectTimeout,
        receiveTimeout: receiveTimeout ?? ApiConfig.defaultTimeout,
        headers: {
          'Accept': 'application/json',
          ...?headers,
        },
      ),
    );

    // Add logging interceptor
    dio.interceptors.add(_LoggingInterceptor());

    // Add retry interceptor
    dio.interceptors.add(_RetryInterceptor(dio));

    return dio;
  }

  /// Converts Dio errors to app-specific exceptions.
  static AppException handleError(DioException error, String source) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request to $source timed out');

      case DioExceptionType.connectionError:
        return NoConnectionException('Failed to connect to $source');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = _extractErrorMessage(error.response);

        if (statusCode == 401 || statusCode == 403) {
          return AuthenticationException(
            message ?? 'Authentication failed',
            source: source,
          );
        }

        if (statusCode == 429) {
          final retryAfter = _parseRetryAfter(error.response);
          return RateLimitException(source: source, retryAfter: retryAfter);
        }

        if (statusCode == 404) {
          return NotFoundException(message ?? 'Resource not found');
        }

        return ApiException(
          message ?? 'API error',
          statusCode: statusCode,
          source: source,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Certificate verification failed for $source',
          originalError: error,
        );

      case DioExceptionType.unknown:
        return NetworkException(
          error.message ?? 'Unknown network error',
          originalError: error,
        );
    }
  }

  static String? _extractErrorMessage(Response? response) {
    if (response?.data == null) return null;

    final data = response!.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['error_description'] as String?;
    }
    return null;
  }

  static Duration? _parseRetryAfter(Response? response) {
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter == null) return null;

    final seconds = int.tryParse(retryAfter);
    if (seconds != null) {
      return Duration(seconds: seconds);
    }
    return null;
  }
}

/// Interceptor for logging requests and responses.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.apiRequest(
      options.method,
      options.uri.toString(),
      params: options.queryParameters.isNotEmpty ? options.queryParameters : null,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.apiResponse(
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.requestOptions.uri}',
      tag: 'Dio',
      error: err.message,
    );
    handler.next(err);
  }
}

/// Interceptor for retrying failed requests.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < _maxRetries) {
      AppLogger.debug(
        'Retrying request (${retryCount + 1}/$_maxRetries): ${err.requestOptions.uri}',
        tag: 'Retry',
      );

      await Future.delayed(_retryDelay * (retryCount + 1));

      try {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        handler.next(e);
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
