import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'api_client_interface.dart';

/// An implementation of [ApiClient] using the Dio package.
///
/// This class handles HTTP requests, configures Dio with base options,
/// sets up interceptors for logging, and provides centralized error handling
/// by converting [DioException]s into custom application [Exception]s.
class DioApiClient implements ApiClient {
  final Dio _dio;

  /// Creates a [DioApiClient] instance.
  ///
  /// Optionally accepts a [Dio] instance for testing purposes.
  /// If no [Dio] instance is provided, a new one is created with
  /// [AppConstants.apiBaseUrl] and [AppConstants.apiTimeout],
  /// along with default headers.
  DioApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: AppConstants.apiTimeout,
              receiveTimeout: AppConstants.apiTimeout,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    _setupInterceptors();
  }

  /// Configures Dio interceptors for logging network requests and responses.
  ///
  /// This method adds an [InterceptorsWrapper] to the Dio instance to log
  /// request details, response status, and error messages to the console.
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _log('REQUEST: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _log(
            'RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _log('ERROR: ${error.type} - ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Logs messages to the console.
  ///
  /// This method is intended for development logging. In a production environment,
  /// a more robust logging solution should be used.
  // ignore: avoid_print
  void _log(String message) {
    debugPrint(message);
  }

  /// Sends an HTTP GET request to the specified [path].
  ///
  /// Throws a custom [Exception] if a [DioException] occurs during the request.
  @override
  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sends an HTTP POST request to the specified [path] with optional [data].
  ///
  /// [data] can be any dynamic object that will be sent as the request body.
  /// Throws a custom [Exception] if a [DioException] occurs during the request.
  @override
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sends an HTTP PUT request to the specified [path] with optional [data].
  ///
  /// [data] can be any dynamic object that will be sent as the request body.
  /// Throws a custom [Exception] if a [DioException] occurs during the request.
  @override
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// Throws a custom [Exception] if a [DioException] occurs during the request.
  @override
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Centralized error handling for [DioException]s.
  ///
  /// This private method converts various [DioExceptionType]s into
  /// specific custom application [Exception]s (e.g., [NetworkException],
  /// [ServerException]) for consistent error management across the app.
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Tempo de conexão esgotado. Verifique sua internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerException(
              message: 'Erro no servidor ($statusCode). Tente novamente.',
              statusCode: statusCode,
            );
          } else if (statusCode >= 400) {
            return ServerException(
              message: 'Requisição inválida ($statusCode).',
              statusCode: statusCode,
            );
          }
        }
        return const ServerException(message: 'Erro na resposta do servidor.');

      case DioExceptionType.cancel:
        return const NetworkException('Requisição cancelada.');

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return const NetworkException(
          'Erro de conexão. Verifique sua internet.',
        );
    }
  }
}
