import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../core/constants/error_messages.dart';
import '../../../domain/usecases/get_subscription_by_slug.dart';
import '../../../domain/usecases/get_subscriptions.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

/// Subscription BLoC.
///
/// Manages the state related to fetching and displaying subscriptions.
/// It processes [SubscriptionEvent]s, orchestrates [UseCase]s from the domain layer,
/// and emits [SubscriptionState]s to update the UI.
///
/// This BLoC acts as a ViewModel, separating presentation logic from business logic.
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptions _getSubscriptions;
  final GetSubscriptionBySlug _getSubscriptionBySlug;

  SubscriptionBloc({
    required GetSubscriptions getSubscriptions,
    required GetSubscriptionBySlug getSubscriptionBySlug,
  }) : _getSubscriptions = getSubscriptions,
       _getSubscriptionBySlug = getSubscriptionBySlug,
       super(const SubscriptionInitial()) {
    on<LoadSubscriptions>(_onLoadSubscriptions);
    on<LoadSubscriptionDetail>(_onLoadSubscriptionDetail);
    on<RefreshSubscriptions>(_onRefreshSubscriptions);
  }

  /// Handles [LoadSubscriptions] events.
  ///
  /// Emits [SubscriptionLoading] to indicate data fetching is in progress.
  /// It then calls the [_getSubscriptions] UseCase.
  /// On success, it emits [SubscriptionLoaded] with the list of subscriptions.
  /// On failure, it maps the [Failure] to a [SubscriptionError] state
  /// using [_mapFailureToErrorState].
  Future<void> _onLoadSubscriptions(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final result = await _getSubscriptions();

    result.fold(
      (failure) => emit(_mapFailureToErrorState(failure)),
      (subscriptions) => emit(SubscriptionLoaded(subscriptions)),
    );
  }

  /// Handles [LoadSubscriptionDetail] events.
  ///
  /// Emits [SubscriptionLoading] to indicate data fetching is in progress.
  /// It then calls the [_getSubscriptionBySlug] UseCase with the provided [slug].
  /// On success, it emits [SubscriptionDetailLoaded] with the specific subscription.
  /// On failure, it maps the [Failure] to a [SubscriptionError] state
  /// using [_mapFailureToErrorState].
  Future<void> _onLoadSubscriptionDetail(
    LoadSubscriptionDetail event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final result = await _getSubscriptionBySlug(event.slug);

    result.fold(
      (failure) => emit(_mapFailureToErrorState(failure)),
      (subscription) => emit(SubscriptionDetailLoaded(subscription)),
    );
  }

  /// Handles [RefreshSubscriptions] events.
  ///
  /// This method calls the [_getSubscriptions] UseCase to refresh the data.
  /// It *does not* emit [SubscriptionLoading] to avoid UI flicker,
  /// which is a common pattern for pull-to-refresh gestures.
  /// On success, it emits [SubscriptionLoaded] with the updated list.
  /// On failure, it maps the [Failure] to a [SubscriptionError] state
  /// using [_mapFailureToErrorState].
  Future<void> _onRefreshSubscriptions(
    RefreshSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _getSubscriptions();

    result.fold(
      (failure) => emit(_mapFailureToErrorState(failure)),
      (subscriptions) => emit(SubscriptionLoaded(subscriptions)),
    );
  }

  /// Maps a [Failure] from the domain layer to an appropriate [SubscriptionError] state.
  ///
  /// This private helper method centralizes error message generation,
  /// providing user-friendly messages based on the type of failure.
  SubscriptionError _mapFailureToErrorState(Failure failure) {
    return switch (failure) {
      ServerFailure() => const SubscriptionError(
        message: ErrorMessages.serverError,
      ),
      NotFoundFailure(:final message) => SubscriptionError(
        message: message.isNotEmpty ? message : ErrorMessages.notFoundError,
      ),
      ValidationFailure(:final errors) => SubscriptionError(
        message: '${ErrorMessages.validationError}${errors.values.join('\n')}',
      ),

      _ => SubscriptionError(
        message: failure.message.isNotEmpty
            ? failure.message
            : ErrorMessages.unknownError,
      ),
    };
  }
}
