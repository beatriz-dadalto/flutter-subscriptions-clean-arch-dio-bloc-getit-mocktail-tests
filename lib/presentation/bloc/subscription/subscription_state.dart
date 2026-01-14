import 'package:equatable/equatable.dart';

import '../../../domain/entities/subscription.dart';

/// Base abstract class for all subscription-related states.
///
/// All specific subscription states must extend this class.
sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// State: Initial state of the subscription BLoC.
///
/// Represents that no subscription data has been loaded yet.
class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

/// State: Subscription data is currently loading.
///
/// Indicates that a request to fetch subscriptions or a specific subscription
/// detail is in progress.
class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

/// State: A list of subscriptions has been successfully loaded.
///
/// Contains the [subscriptions] list. Provides helper getters for UI.
class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> subscriptions;

  const SubscriptionLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];

  /// UI helpers
  bool get isEmpty => subscriptions.isEmpty;
  int get count => subscriptions.length;
}

/// State: Detailed information for a single subscription has been successfully loaded.
///
/// Contains the [subscription] entity.
class SubscriptionDetailLoaded extends SubscriptionState {
  final Subscription subscription;

  const SubscriptionDetailLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

/// State: An error occurred during a subscription operation.
///
/// Contains an error [message] and a flag [isNetworkError] to indicate
/// if the error was network-related.
class SubscriptionError extends SubscriptionState {
  final String message;
  final bool isNetworkError;

  const SubscriptionError({required this.message, this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
