import 'package:equatable/equatable.dart';

/// Base class for all application failures.
///
/// Failures are returned as values (e.g., `Either<Failure, Success>`)
/// and encapsulate information about an error that occurred.
/// This provides a structured way to handle errors across different layers
/// of the application.
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final List<Object?> properties;

  /// Creates a [Failure] with an optional [message], [code], and additional [properties].
  ///
  /// [message] provides a human-readable description of the failure.
  /// [code] offers a machine-readable identifier for the failure type.
  /// [properties] are used by [Equatable] for value comparison.
  const Failure({
    this.message = 'Ocorreu um erro inesperado.',
    this.code,
    this.properties = const [],
  });

  @override
  List<Object?> get props => [message, code, ...properties]; // Inclui as propriedades adicionais

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Represents a generic server-side failure (e.g., 500 Internal Server Error).
class ServerFailure extends Failure {
  final int? statusCode;

  /// Creates a [ServerFailure] with an optional [message], [statusCode], and [code].
  ServerFailure({
    super.message = 'Erro no servidor. Tente novamente mais tarde.',
    this.statusCode,
    super.code = 'SERVER_ERROR',
  }) : super(properties: [statusCode]);
}

/// Represents a data validation failure (e.g., missing required fields).
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  /// Creates a [ValidationFailure] with required [errors] details, an optional [message], and [code].
  ValidationFailure({
    required this.errors,
    super.message = 'Dados inválidos. Por favor, verifique os campos.',
    super.code = 'VALIDATION_ERROR',
  }) : super(properties: [errors]);
}

/// Represents a failure where the requested resource was not found (e.g., 404 Not Found).
class NotFoundFailure extends Failure {
  /// Creates a [NotFoundFailure] with an optional [message] and [code].
  const NotFoundFailure({
    super.message = 'Recurso não encontrado.',
    super.code = 'NOT_FOUND',
  });
}

/// Represents a network connection failure.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with an optional [message] and [code].
  const NetworkFailure({
    super.message = 'Sem conexão com a internet. Verifique sua conexão.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Represents a failure when accessing or saving local cache data.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erro ao acessar dados locais. Tente novamente.',
    super.code = 'CACHE_ERROR',
  });
}

/// Represents an authentication failure (e.g., invalid credentials, expired token).
class AuthFailure extends Failure {
  /// Creates an [AuthFailure] with an optional [message] and [code].
  const AuthFailure({
    super.message = 'Falha na autenticação. Verifique suas credenciais.',
    super.code = 'AUTH_ERROR',
  });
}

/// Represents an unknown or unexpected failure that does not fit other categories.
class UnknownFailure extends Failure {
  /// Creates an [UnknownFailure] with an optional [message] and [code].
  const UnknownFailure({
    super.message = 'Ocorreu um erro inesperado. Tente novamente mais tarde.',
    super.code = 'UNKNOWN_ERROR',
  });
}
