import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../config/env_config.dart';

/// Simple logging utility for the app.
class AppLogger {
  AppLogger._();

  static const String _tag = 'ShoppingAssistant';

  /// Log debug messages (only in debug mode).
  static void debug(String message, {String? tag}) {
    if (kDebugMode || EnvConfig.isDebug) {
      _log('DEBUG', message, tag: tag);
    }
  }

  /// Log info messages.
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Log warning messages.
  static void warning(String message, {String? tag, Object? error}) {
    _log('WARN', message, tag: tag, error: error);
  }

  /// Log error messages.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log API request.
  static void apiRequest(String method, String url, {Map<String, dynamic>? params}) {
    if (kDebugMode || EnvConfig.isDebug) {
      final paramsStr = params != null ? ' params=$params' : '';
      _log('API', '$method $url$paramsStr', tag: 'Request');
    }
  }

  /// Log API response.
  static void apiResponse(String url, int statusCode, {int? durationMs}) {
    if (kDebugMode || EnvConfig.isDebug) {
      final duration = durationMs != null ? ' (${durationMs}ms)' : '';
      _log('API', '$url -> $statusCode$duration', tag: 'Response');
    }
  }

  static void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final effectiveTag = tag != null ? '$_tag/$tag' : _tag;
    final logMessage = '[$level] $message';

    if (kDebugMode) {
      developer.log(
        logMessage,
        name: effectiveTag,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // In release mode, only log warnings and errors
      if (level == 'WARN' || level == 'ERROR') {
        // ignore: avoid_print
        print('$effectiveTag: $logMessage');
        if (error != null) {
          // ignore: avoid_print
          print('  Error: $error');
        }
      }
    }
  }
}
