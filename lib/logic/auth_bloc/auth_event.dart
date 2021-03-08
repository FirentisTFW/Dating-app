part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin(this.email, this.password);
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;

  AuthRegister(this.email, this.password);
}

class AuthCheckIfLoggedIn extends AuthEvent {}

class AuthSignOut extends AuthEvent {}
