import '../../core/types/result_types.dart';

/// Base interface for a UseCase without parameters.
///
/// Implementations should execute an asynchronous operation and return a [Result]
/// with the expected data type.
/// Example: automatic authentication, initial data loading, etc.
abstract interface class UseCase<T> {
  Future<Result<T>> call();
}

/// Interface for UseCases that receive parameters.
///
/// Implementations should execute an asynchronous operation using [params]
/// and return a [Result] with the expected data type.
/// Example: login, filtered search, etc.
abstract interface class UseCaseWithParams<T, P> {
  Future<Result<T>> call(P params);
}

/// Interface for UseCases that return a [VoidResult] and receive parameters.
///
/// Used for operations that do not return data, only success or failure,
/// and require parameters.
/// Example: logout, item deletion, etc.
abstract interface class VoidUseCase<P> {
  Future<VoidResult> call(P params);
}

/// Interface for UseCases that return a [VoidResult] and do not receive parameters.
///
/// Used for operations that do not return data and do not require parameters.
/// Example: cache clearing, context-less logout, etc.
abstract interface class VoidUseCaseNoParams {
  Future<VoidResult> call();
}
