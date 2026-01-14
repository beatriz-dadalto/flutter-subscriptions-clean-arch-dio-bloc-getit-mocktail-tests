import 'package:empiricus_app_dev_beatriz_dadalto/core/types/result_types.dart';

/// Contract for the Authentication Repository.
///
/// Defines the available operations for user authentication without exposing
/// implementation details.
abstract class AuthRepository {

  Future<Result<String>> login({
    required String email,
    required String password,
  });
  Future<VoidResult> logout();
  Future<bool> isAuthenticated();
  
}
