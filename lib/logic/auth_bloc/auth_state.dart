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

class AuthRegistrationSuccess extends AuthState {}

class AuthSignOutSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthException extends AuthState {
  final String message;

  AuthException({this.message});

  @override
  List<Object> get props => [message];
}
