import '../../core/types/result_types.dart';
import '../entities/subscription.dart';

/// Contract for the Subscription Repository.
///
/// Defines the available operations for managing subscriptions without exposing
/// implementation details.
abstract interface class SubscriptionRepository {
  Future<Result<List<Subscription>>> getSubscriptions();
  Future<Result<Subscription>> getSubscriptionBySlug(String slug);
}
