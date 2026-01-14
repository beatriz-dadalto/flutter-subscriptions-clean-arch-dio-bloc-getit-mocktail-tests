import 'package:equatable/equatable.dart';

/// Base abstract class for all authentication events.
///
/// All specific authentication events must extend this class.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event: Requests a user login.
///
/// Contains the [email] and [password] provided by the user.
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Event: Requests a user logout.
///
/// This event does not require any parameters.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event: Requests an authentication status check.
///
/// Typically dispatched on application startup (e.g., from the splash screen)
/// to determine if a user is already authenticated.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();

  @override
  List<Object> get props => [];
}
