import 'dart:async';

import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield AuthWaiting();

    if (event is AuthLogin) {
      try {
        await _repository.signInUser(event.email, event.password);
        yield AuthLoginSuccess();
      } catch (err) {
        yield AuthLoginError();
      }
    }
  }
}
