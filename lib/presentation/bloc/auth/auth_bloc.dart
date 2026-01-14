import 'package:empiricus_app_dev_beatriz_dadalto/domain/repositories/auth_repository_interface.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/login_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC.
///
/// Manages the authentication state of the application by processing [AuthEvent]s,
/// interacting with [LoginUseCase], [LogoutUseCase], and [AuthRepository],
/// and emitting [AuthState]s.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  AuthBloc(this._loginUseCase, this._logoutUseCase, this._authRepository)
    : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  /// Handles [LoginRequested] events.
  ///
  /// Emits [AuthLoading], then calls [LoginUseCase] with provided credentials.
  /// On success, emits [AuthSuccess] with user email.
  /// On failure, emits [AuthFailure] with an error message.
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (token) => emit(AuthSuccess(userEmail: token)),
    );
  }

  /// Handles [LogoutRequested] events.
  ///
  /// Emits [AuthLoading], then calls [LogoutUseCase].
  /// On success, emits [AuthInitial].
  /// On failure, emits [AuthFailure] with an error message.
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (success) => emit(const AuthInitial()),
    );
  }

  /// Handles [AuthCheckRequested] events.
  ///
  /// Checks the authentication status using [AuthRepository].
  /// If authenticated, emits [AuthSuccess].
  /// If not authenticated, emits [AuthInitial].
  /// Note: Does not emit [AuthLoading] to avoid UI flicker on splash screen.
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    if (isAuthenticated) {
      emit(const AuthSuccess(userEmail: 'usuário logado'));
    } else {
      emit(const AuthInitial());
    }
  }
}
