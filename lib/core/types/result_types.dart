import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

/// Type aliases for the Result Pattern using `fpdart`'s `Either`.
///
/// This pattern provides a clear way to represent operations that can either
/// succeed with a value (`Right`) or fail with an error (`Left`).
///
/// - `Left` represents a [Failure].
/// - `Right` represents a successful data of type [T].
///
/// Usage examples:
///
/// ```dart
/// Future<Result<User>> getUserById(String id);
/// Future<Result<List<Product>>> getProducts();
/// Future<VoidResult> deleteItem(String id);
/// ```

/// [Result] is a type alias for `Either<Failure, T>`.
typedef Result<T> = Either<Failure, T>;

/// [VoidResult] is a type alias for `Either<Failure, Unit>`, used for operations that do not return a value on success.
/// On success, it returns [Unit] (from fpdart), which signifies the absence of a meaningful value.
/// On failure, it returns a [Failure].
typedef VoidResult = Either<Failure, Unit>;
