/// Custom application-specific exceptions.
///
/// This library defines a set of custom exception classes to provide
/// more specific and meaningful error handling across different layers
/// of the application, improving readability and maintainability
/// compared to generic exceptions.
library;

/// Exception thrown when a server-side error occurs (e.g., 5xx or 4xx status codes).
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  /// Creates a [ServerException] with a required [message] and an optional [statusCode].
  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

/// Exception thrown when a requested resource is not found (e.g., 404 status code).
class NotFoundException implements Exception {
  final String message;

  /// Creates a [NotFoundException] with an optional [message].
  const NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when a network-related error occurs (e.g., connection issues, timeouts).
class NetworkException implements Exception {
  final String message;

  /// Creates a [NetworkException] with an optional [message].
  const NetworkException([this.message = 'Network error']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when an error occurs during cache operations.
class CacheException implements Exception {
  final String message;

  /// Creates a [CacheException] with an optional [message].
  const CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when an error occurs during data parsing or serialization.
class ParseException implements Exception {
  final String message;

  /// Creates a [ParseException] with an optional [message].
  const ParseException([this.message = 'Parse error']);

  @override
  String toString() => 'ParseException: $message';
}
