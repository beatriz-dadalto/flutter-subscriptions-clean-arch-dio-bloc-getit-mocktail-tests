// lib/data/repositories/auth_repository_impl.dart
import 'package:empiricus_app_dev_beatriz_dadalto/core/types/result_types.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository_interface.dart';

/// Implementation of the [AuthRepository] interface.
///
/// This class handles user authentication logic and
/// persists authentication tokens using [SharedPreferences].
class AuthRepositoryImpl implements AuthRepository {
  // Fixed credentials for the technical challenge simulation.
  static const _fixedEmail = "admin@email.com";
  static const _fixedPassword = "123456";

  static const _tokenKey = 'auth_token';

  @override
  Future<Result<String>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulates network delay

    if (_isValidCredentials(email, password)) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_tokenKey, 'mock_token_for_$email');
      return Right(email);
    } else {
      return Left(const AuthFailure(message: 'Email ou senha inválidos'));
    }
  }

  @override
  Future<VoidResult> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    return Right(unit);
  }

  @override
  Future<bool> isAuthenticated() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  bool _isValidCredentials(String email, String password) {
    return email == _fixedEmail && password == _fixedPassword;
  }
}
