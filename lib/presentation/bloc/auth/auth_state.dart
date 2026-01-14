import 'package:equatable/equatable.dart';

/// Base abstract class for all authentication states.
///
/// All specific authentication states must extend this class.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// State: Initial state of the authentication BLoC.
///
/// Represents that no authentication action has been taken yet,
/// or the user is not authenticated.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State: Authentication process is currently loading.
///
/// Indicates that a login, logout, or authentication check operation is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State: User is successfully authenticated.
///
/// Contains the [userEmail] (or a full user object) of the authenticated user.
class AuthSuccess extends AuthState {
  final String userEmail; // Ou um objeto User completo
  const AuthSuccess({required this.userEmail});

  @override
  List<Object> get props => [userEmail];
}

/// State: Authentication process failed.
///
/// Contains a [message] explaining the reason for the failure.
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
