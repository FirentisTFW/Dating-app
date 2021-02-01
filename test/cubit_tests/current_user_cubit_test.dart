import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsersRepositoryMock extends Mock implements UsersRepository {}

class AuthenticationRepositoryMock extends Mock
    implements AuthenticationRepository {}

void main() {
  group('CurrentUserCubitTest -', () {
    UsersRepositoryMock usersRepository;
    AuthenticationRepositoryMock authenticationRepository;
    final user = User(
      id: '1',
      birthDate: DateTime(1995, 1, 1),
      gender: Gender.Man,
      name: 'Tester',
    );
    final incompleteUser =
        User(id: '11', birthDate: null, name: null, gender: null);

    setUp(() {
      usersRepository = UsersRepositoryMock();
      authenticationRepository = AuthenticationRepositoryMock();
    });
    group('updateUser -', () {
      final oldUser = user;
      final updatedUser = oldUser.copyWith(caption: 'Just testing');

      blocTest(
        'When successful, emits [CurrentUserWaiting, CurrentUserReady(updatedUser)]',
        build: () {
          when(usersRepository.updateUser(any)).thenAnswer((_) async => null);
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) =>
            cubit.updateUser(oldUser: oldUser, updatedUser: updatedUser),
        expect: [
          CurrentUserWaiting(),
          CurrentUserReady(user: updatedUser),
        ],
      );
      blocTest(
          'When failure, emits [CurrentUserWaiting, CurrentUserError(oldUser)',
          build: () {
            when(usersRepository.updateUser(any))
                .thenThrow(ErrorDescription('An error occured'));
            return CurrentUserCubit(usersRepository, authenticationRepository);
          },
          act: (cubit) =>
              cubit.updateUser(oldUser: oldUser, updatedUser: updatedUser),
          expect: [
            CurrentUserWaiting(),
            CurrentUserError(user: oldUser),
          ]);
    });
    group('createUser -', () {
      blocTest(
        'When successful, emits [CurrentUserWaiting, CurrentUserProfileIncomplete(user)]',
        build: () {
          when(usersRepository.createUser(any)).thenAnswer((_) async => null);
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) => cubit.createUser(user),
        expect: [
          CurrentUserWaiting(),
          CurrentUserProfileIncomplete(user: user),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(usersRepository.createUser(any))
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) => cubit.createUser(user),
        expect: [
          CurrentUserWaiting(),
          CurrentUserError(),
        ],
      );
    });
    group('checkIfProfileIsComplete -', () {
      blocTest(
        'When profile is complete, emits [CurrentUserWaiting, CurrentUserReady]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUser(any)).thenAnswer((_) async => user);
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserReady(user: user),
        ],
      );
      blocTest(
        'When profile is incomplete, emits [CurrentUserWaiting, CurrentUserProfileIncomplete]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUser(any))
              .thenAnswer((_) async => incompleteUser);
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserProfileIncomplete(user: incompleteUser),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUser(any))
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(usersRepository, authenticationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserError(),
        ],
      );
    });
  });
}
