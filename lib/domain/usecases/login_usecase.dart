import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../../core/types/result_types.dart';
import '../repositories/auth_repository_interface.dart';

/// Parameters for the [LoginUseCase].
///
/// Encapsulates the required data for a login attempt: [email] and [password].
class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

/// UseCase: Handles user login.
///
/// This UseCase implements the [UseCaseWithParams] interface for standardization.
/// Its responsibilities include:
/// - Being testable in isolation (only mocks the repository).
/// - Being reusable across different BLoCs/ViewModels.
/// - Orchestrating the login process by delegating to [AuthRepository].
/// - Performing input validation on the provided [LoginParams].
class LoginUseCase implements UseCaseWithParams<String, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<String>> call(LoginParams params) async {
    if (params.email.isEmpty || !params.email.contains('@')) {
      return left(
        ValidationFailure(errors: {'email': 'E-mail inválido'}),
      );
    }
    if (params.password.isEmpty || params.password.length < 4) {
      return left(
        ValidationFailure(errors: {'password': 'Senha muito curta'}),
      );
    }
    return repository.login(email: params.email, password: params.password);
  }
}
