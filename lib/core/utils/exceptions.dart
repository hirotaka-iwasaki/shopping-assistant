/// Base exception class for the shopping assistant app.
sealed class AppException implements Exception {
  const AppException(this.message, {this.originalError});

  final String message;
  final Object? originalError;

  @override
  String toString() => '$runtimeType: $message';
}

/// Network-related exceptions.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.originalError});
}

/// Exception thrown when a request times out.
class TimeoutException extends NetworkException {
  const TimeoutException([super.message = 'Request timed out']);
}

/// Exception thrown when there's no internet connection.
class NoConnectionException extends NetworkException {
  const NoConnectionException([super.message = 'No internet connection']);
}

/// Exception thrown when API rate limit is exceeded.
class RateLimitException extends AppException {
  const RateLimitException({
    required this.source,
    this.retryAfter,
  }) : super('Rate limit exceeded for $source');

  final String source;
  final Duration? retryAfter;
}

/// Exception thrown when API key is invalid or missing.
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {required this.source});

  final String source;
}

/// Exception thrown when API returns an error response.
class ApiException extends AppException {
  const ApiException(
    super.message, {
    required this.statusCode,
    required this.source,
    super.originalError,
  });

  final int statusCode;
  final String source;
}

/// Exception thrown when parsing response data fails.
class ParseException extends AppException {
  const ParseException(super.message, {super.originalError});
}

/// Exception thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

/// Enum representing different EC platforms.
enum EcSource {
  amazon('Amazon'),
  rakuten('楽天市場'),
  yahoo('Yahoo!ショッピング'),
  qoo10('Qoo10');

  const EcSource(this.displayName);
  final String displayName;
}
