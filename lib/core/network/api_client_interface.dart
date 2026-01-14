import 'package:dio/dio.dart';

/// Abstract contract for an HTTP client.
///
/// This interface defines the standard operations for making HTTP requests
/// (GET, POST, PUT, DELETE) within the application, ensuring a consistent
/// way to interact with external APIs regardless of the underlying
/// implementation (e.g., Dio, Http package).
abstract class ApiClient {
  /// Sends an HTTP GET request to the specified [path].
  ///
  /// Returns a [Response] object containing the server's response.
  Future<Response> get(String path);

  /// Sends an HTTP POST request to the specified [path] with optional [data].
  ///
  /// [data] can be any dynamic object that will be sent as the request body.
  /// Returns a [Response] object.
  Future<Response> post(String path, {dynamic data});

  /// Sends an HTTP PUT request to the specified [path] with optional [data].
  ///
  /// [data] can be any dynamic object that will be sent as the request body.
  /// Returns a [Response] object.
  Future<Response> put(String path, {dynamic data});

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// Returns a [Response] object.
  Future<Response> delete(String path);
}
