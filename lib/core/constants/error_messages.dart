/// Centralized error messages for the application.
///
/// This class provides a single source of truth for user-facing error messages,
/// ensuring consistency across the UI and simplifying maintenance and future
/// internationalization efforts.
abstract final class ErrorMessages {
  ErrorMessages._();

  /// Message displayed for server-related errors (e.g., 500 Internal Server Error).
  static const String serverError =
      'Erro no servidor.\n\n'
      'Estamos trabalhando para resolver. '
      'Tente novamente em alguns instantes.';

  /// Message displayed for network connectivity issues.
  static const String networkError =
      'Sem conexão com a internet.\n\n'
      'Verifique sua conexão e tente novamente.';

  /// Message displayed when a requested resource is not found (e.g., 404 Not Found).
  static const String notFoundError =
      'Assinatura não encontrada.\n\n'
      'Verifique o link e tente novamente.';

  /// Message displayed for data validation failures.
  static const String validationError = 'Dados inválidos.\n\n';

  /// Message displayed for unknown or unexpected errors.
  static const String unknownError =
      'Ocorreu um erro inesperado.\n\n'
      'Tente novamente mais tarde.';

  /// Generic message for failures during data loading operations.
  static const String genericLoadFailure =
      'Falha ao carregar. Tente novamente mais tarde.';
}
