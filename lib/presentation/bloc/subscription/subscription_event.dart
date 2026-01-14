import 'package:equatable/equatable.dart';

/// Base abstract class for all subscription-related events.
///
/// All specific subscription events must extend this class.
sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event: Requests to load the list of all available subscriptions.
///
/// This event does not require any parameters.
class LoadSubscriptions extends SubscriptionEvent {
  const LoadSubscriptions();
}

/// Event: Requests to load the detailed information for a specific subscription.
///
/// Contains the [slug] of the subscription to be loaded.
class LoadSubscriptionDetail extends SubscriptionEvent {
  final String slug;

  const LoadSubscriptionDetail({required this.slug});

  @override
  List<Object?> get props => [slug];
}

/// Event: Requests to refresh the list of subscriptions.
///
/// Typically dispatched by a pull-to-refresh gesture.
/// This event does not require any parameters.
class RefreshSubscriptions extends SubscriptionEvent {
  const RefreshSubscriptions();
}
