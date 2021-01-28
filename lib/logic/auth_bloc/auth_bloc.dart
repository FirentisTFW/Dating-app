import 'dart:async';

import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      } on FirebaseAuthException catch (err) {
        yield AuthLoginFailure(err.message);
      } catch (err) {
        yield AuthLoginError(err.message);
      }
    } else if (event is AuthCheckIfLoggedIn) {
      try {
        if (_repository.isUserLoggedIn) {
          yield AuthLoginSuccess();
        } else {
          yield AuthReady();
        }
      } catch (err) {
        yield AuthLoginError(err.message);
      }
    }
  }
}
