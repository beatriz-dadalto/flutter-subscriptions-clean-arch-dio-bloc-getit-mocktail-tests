import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../../core/types/result_types.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository_interface.dart';
import 'usecase.dart';

/// UseCase: Fetches a specific subscription by its slug.
///
/// This UseCase implements the [UseCaseWithParams] interface for standardization.
/// Its responsibilities include:
/// - Being testable in isolation (only mocks the repository).
/// - Being reusable across different BLoCs/ViewModels.
/// - Orchestrating the retrieval of subscription data from the repository.
/// - Performing input validation on the provided [slug].
class GetSubscriptionBySlug implements UseCaseWithParams<Subscription, String> {
  final SubscriptionRepository _repository;

  const GetSubscriptionBySlug(this._repository);

  @override
  Future<Result<Subscription>> call(String slug) async {
    if (slug.isEmpty) {
      return left(
        ValidationFailure(errors: {'slug': 'Slug não pode ser vazio'}),
      );
    }

    if (slug.length < 2) {
      return left(
        ValidationFailure(
          errors: {'slug': 'Slug deve ter pelo menos 2 caracteres'},
        ),
      );
    }

    return _repository.getSubscriptionBySlug(slug);
  }
}
