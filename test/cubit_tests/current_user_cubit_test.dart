import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsersRepositoryMock extends Mock implements UsersRepository {}

class AuthenticationRepositoryMock extends Mock
    implements AuthenticationRepository {}

class LocationRepositoryMock extends Mock implements LocationRepository {}

void main() {
  group('CurrentUserCubitTest -', () {
    UsersRepositoryMock usersRepository;
    AuthenticationRepositoryMock authenticationRepository;
    LocationRepositoryMock locationRepository;

    final discoverySettings = DiscoverySettings(
        gender: Gender.Woman, ageMin: 20, ageMax: 30, distance: 30);
    final user = User(
        id: '1',
        birthDate: DateTime(1995, 1, 1),
        gender: Gender.Man,
        name: 'Tester',
        discoverySettings: discoverySettings);
    final userMissingName =
        User(id: '11', birthDate: null, name: null, gender: null);
    final userMissingDiscoverySettings = User(
        id: '1',
        birthDate: DateTime(1995, 1, 1),
        gender: Gender.Man,
        name: 'Tester',
        discoverySettings: null);

    setUp(() {
      usersRepository = UsersRepositoryMock();
      authenticationRepository = AuthenticationRepositoryMock();
      locationRepository = LocationRepositoryMock();
    });
    group('updateUser -', () {
      final oldUser = user;
      final updatedUser = oldUser.copyWith(caption: 'Just testing');

      blocTest(
        'When successful, emits [CurrentUserWaiting, CurrentUserReady(updatedUser)]',
        build: () {
          when(usersRepository.updateUser(any)).thenAnswer((_) async => null);
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) =>
            cubit.updateUser(oldUser: oldUser, updatedUser: updatedUser),
        expect: [
          CurrentUserWaiting(),
          CurrentUserReady(updatedUser),
        ],
      );
      blocTest(
          'When failure, emits [CurrentUserWaiting, CurrentUserError(oldUser)',
          build: () {
            when(usersRepository.updateUser(any))
                .thenThrow(ErrorDescription('An error occured'));
            return CurrentUserCubit(
                usersRepository, authenticationRepository, locationRepository);
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
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.createUser(user),
        expect: [
          CurrentUserWaiting(),
          CurrentUserProfileIncomplete(
              user: user,
              profileStatus: ProfileStatus.MissingDiscoverySettings),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(usersRepository.createUser(any))
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
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
          when(usersRepository.getUserByAuthId(any))
              .thenAnswer((_) async => user);
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserReady(user),
        ],
      );
      blocTest(
        'When profile is incomplete (missing personal data), emits [CurrentUserWaiting, CurrentUserProfileIncomplete]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUserByAuthId(any))
              .thenAnswer((_) async => null);
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserProfileIncomplete(
              user: userMissingName,
              profileStatus: ProfileStatus.MissingPersonalData),
        ],
      );
      blocTest(
        'When profile is incomplete (missing discovery settings), emits [CurrentUserWaiting, CurrentUserProfileIncomplete]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUserByAuthId(any))
              .thenAnswer((_) async => userMissingDiscoverySettings);
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserProfileIncomplete(
              user: userMissingName,
              profileStatus: ProfileStatus.MissingDiscoverySettings),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.getUserByAuthId(any))
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.checkIfProfileIsComplete(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserError(),
        ],
      );
    });
    group('updateDiscoverySettings -', () {
      blocTest(
        'When successful, emits [CurrentUserWaiting, CurrentUserReady]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.updateDiscoverySettings(any, any, any))
              .thenAnswer((_) async => null);
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.updateDiscoverySettings(user, discoverySettings),
        expect: [
          CurrentUserWaiting(),
          CurrentUserReady(user),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(authenticationRepository.userId).thenReturn('1');
          when(usersRepository.updateDiscoverySettings(any, any, any))
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.updateDiscoverySettings(user, discoverySettings),
        expect: [
          CurrentUserWaiting(),
          CurrentUserError(user: user),
        ],
      );
    });
    group('getCurrentLocation -', () {
      final location = CustomLocation(latitude: 12.34, longitude: 12.34);
      blocTest(
        'When successful, emits [CurrentUserWaiting, CurrentUserLocationReceived]',
        build: () {
          when(locationRepository.getCurrentLocation()).thenAnswer(
              (_) async => CustomLocation(latitude: 12.34, longitude: 12.34));
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.getCurrentLocation(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserLocationReceived(location),
        ],
      );
      blocTest(
        'When failure, emits [CurrentUserWaiting, CurrentUserError]',
        build: () {
          when(locationRepository.getCurrentLocation())
              .thenThrow(ErrorDescription('An error occured'));
          return CurrentUserCubit(
              usersRepository, authenticationRepository, locationRepository);
        },
        act: (cubit) => cubit.getCurrentLocation(),
        expect: [
          CurrentUserWaiting(),
          CurrentUserError(message: 'Check device location permissions'),
        ],
      );
    });
  });
}
