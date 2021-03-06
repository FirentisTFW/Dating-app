import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthenticationRepositoryMock extends Mock
    implements AuthenticationRepository {}

void main() {
  AuthenticationRepositoryMock authenticationRepository;

  group('AuthBlocTest -', () {
    setUp(() {
      authenticationRepository = AuthenticationRepositoryMock();
    });
    group('AuthLogin -', () {
      blocTest(
        'When successful, emits [AuthWaiting, AuthLoginSuccess]',
        build: () {
          when(authenticationRepository.signInUser(any, any))
              .thenAnswer((_) async => null);
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthLogin('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthLoginSuccess(),
        ],
      );
      blocTest(
        'When failure (wrong password or e-mail), emits [AuthWaiting, AuthFailure]',
        build: () {
          when(authenticationRepository.signInUser(any, any)).thenThrow(
              FirebaseAuthException(
                  message: 'Authentication failed', code: '401'));
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthLogin('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthFailure('Authentication failed'),
        ],
      );
      blocTest(
        'When there is another exception thrown, emits [AuthWaiting, AuthException]',
        build: () {
          when(authenticationRepository.signInUser(any, any))
              .thenThrow(Exception('An error occured'));
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthLogin('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthException(),
        ],
      );
    });

    group('AuthCheckIfLoggedIn -', () {
      blocTest(
        'When user is logged in, emits [AuthWaiting, AuthLoginSuccess]',
        build: () {
          when(authenticationRepository.isUserLoggedIn).thenReturn(true);
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthCheckIfLoggedIn()),
        expect: [
          AuthWaiting(),
          AuthLoginSuccess(),
        ],
      );
      blocTest(
        'When user is not logged in, emits [AuthWaiting, AuthReady]',
        build: () {
          when(authenticationRepository.isUserLoggedIn).thenReturn(false);
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthCheckIfLoggedIn()),
        expect: [
          AuthWaiting(),
          AuthReady(),
        ],
      );
      blocTest(
        'When there is an exception thrown, emits [AuthWaiting, AuthException]',
        build: () {
          when(authenticationRepository.isUserLoggedIn)
              .thenThrow(Exception('An error occured'));
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthCheckIfLoggedIn()),
        expect: [
          AuthWaiting(),
          AuthException(),
        ],
      );
    });
    group('AuthRegister -', () {
      blocTest(
        'When successful, emits [AuthWaiting, AuthRegistrationSuccess]',
        build: () {
          when(authenticationRepository.registerUser(any, any))
              .thenAnswer((_) async => null);
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthRegister('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthRegistrationSuccess(),
        ],
      );
      blocTest(
        'When failure (email already in use etc.), emits [AuthWaiting, AuthRegistrationSuccess]',
        build: () {
          when(authenticationRepository.registerUser(any, any)).thenThrow(
              FirebaseAuthException(
                  message: 'Registration failed', code: '400'));
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthRegister('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthFailure('Registration failed'),
        ],
      );
      blocTest(
        'When there is another exception thrown, emits [AuthWaiting, AuthException]',
        build: () {
          when(authenticationRepository.registerUser(any, any))
              .thenThrow(Exception('An error occured'));
          return AuthBloc(authenticationRepository);
        },
        act: (bloc) => bloc.add(AuthRegister('test@test.com', 'test')),
        expect: [
          AuthWaiting(),
          AuthException(),
        ],
      );
    });
  });
}
