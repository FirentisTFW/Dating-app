import 'dart:async';

import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield AuthWaiting();

    if (event is AuthLogin) {
      yield* _mapAuthLoginToState(event);
    } else if (event is AuthCheckIfLoggedIn) {
      yield* _mapAuthCheckIfLoggedInToState(event);
    } else if (event is AuthRegister) {
      yield* _mapAuthRegisterToState(event);
    } else if (event is AuthSignOut) {
      yield* _mapAuthSignOutToState(event);
    }
  }

  Stream<AuthState> _mapAuthLoginToState(AuthLogin event) async* {
    try {
      await _authRepository.signInUser(event.email, event.password);
      yield AuthLoginSuccess();
    } on FirebaseAuthException catch (err) {
      yield AuthFailure(err.message);
    } on Exception {
      yield AuthException();
    }
  }

  Stream<AuthState> _mapAuthCheckIfLoggedInToState(
      AuthCheckIfLoggedIn event) async* {
    try {
      if (_authRepository.isUserLoggedIn) {
        yield AuthLoginSuccess();
      } else {
        yield AuthReady();
      }
    } on Exception {
      yield AuthException();
    }
  }

  Stream<AuthState> _mapAuthRegisterToState(AuthRegister event) async* {
    try {
      await _authRepository.registerUser(event.email, event.password);
      yield AuthRegistrationSuccess();
    } on FirebaseAuthException catch (err) {
      yield AuthFailure(err.message);
    } on Exception {
      yield AuthException();
    }
  }

  Stream<AuthState> _mapAuthSignOutToState(AuthSignOut event) async* {
    try {
      await _authRepository.signOutUser();
      yield AuthSignOutSuccess();
    } on FirebaseAuthException catch (err) {
      yield AuthFailure(err.message);
    } on Exception {
      yield AuthException();
    }
  }
}
