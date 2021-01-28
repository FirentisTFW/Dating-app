part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthReady extends AuthState {}

class AuthWaiting extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure(this.message);
}

class AuthLoginError extends AuthState {
  final String message;

  AuthLoginError(this.message);
}
