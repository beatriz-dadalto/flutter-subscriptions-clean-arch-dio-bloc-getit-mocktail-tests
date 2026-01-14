import '../../core/types/result_types.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository_interface.dart';
import 'usecase.dart';

/// UseCase: Fetches all available subscriptions.
///
/// This UseCase implements the [UseCase] interface for standardization.
/// Its responsibilities include:
/// - Being testable in isolation (only mocks the repository).
/// - Being reusable across different BLoCs/ViewModels.
/// - Orchestrating the retrieval of subscription data from the repository.
class GetSubscriptions implements UseCase<List<Subscription>> {
  final SubscriptionRepository _repository;

  const GetSubscriptions(this._repository);

  @override
  Future<Result<List<Subscription>>> call() async {
    return _repository.getSubscriptions();
  }
}
