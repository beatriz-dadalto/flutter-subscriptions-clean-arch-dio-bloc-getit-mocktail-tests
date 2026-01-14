import '../../core/types/result_types.dart';
import '../repositories/auth_repository_interface.dart';
import 'usecase.dart';

/// UseCase: Handles user logout.
///
/// This UseCase implements the [VoidUseCaseNoParams] interface for standardization.
/// Its responsibilities include:
/// - Being testable in isolation (only mocks the repository).
/// - Being reusable across different BLoCs/ViewModels.
/// - Orchestrating the logout process by delegating to [AuthRepository].
class LogoutUseCase implements VoidUseCaseNoParams {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<VoidResult> call() async {
    return _repository.logout();
  }
}
