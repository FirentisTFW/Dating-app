import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsersRepositoryMock extends Mock implements UsersRepository {}

void main() {
  UsersRepositoryMock usersRepository;

  final user = User(
      id: '433',
      name: 'Jason',
      birthDate: DateTime(1997, 01, 01),
      gender: Gender.Man,
      location: CustomLocation(latitude: 12.34, longitude: 12.34));
  final fetchedUsers = [
    User(
        id: '1',
        name: 'Megan',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
    User(
        id: '2',
        name: 'Lucy',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
    User(
        id: '3',
        name: 'Hannah',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
    User(
        id: '4',
        name: 'Stacy',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
  ];
  final rejectedUsersIds = ['1'];
  final acceptedUsersIds = ['3'];
  final remainingUsers = [
    User(
        id: '2',
        name: 'Lucy',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
    User(
        id: '4',
        name: 'Stacy',
        birthDate: DateTime(1998, 01, 01),
        gender: Gender.Woman),
  ];
  final exceptionMessage = 'An exception occured';

  group('DiscoveryBlocTest -', () {
    setUp(() {
      usersRepository = UsersRepositoryMock();
    });
    group('FetchAndFilterUsers -', () {
      blocTest(
          'When successful, emits [DiscoveryWaiting, DiscoveryUsersFetched]',
          build: () {
            when(usersRepository.getUsersByDiscoverySettings(any,
                    location: anyNamed('location')))
                .thenAnswer((_) async => fetchedUsers);
            when(usersRepository.getUserRejections(any))
                .thenAnswer((_) async => rejectedUsersIds);
            when(usersRepository.getUserAcceptances(any))
                .thenAnswer((_) async => acceptedUsersIds);
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(FetchAndFilterUsers(user: user)),
          expect: [
            DiscoveryWaiting(),
            DiscoveryUsersFetched(remainingUsers),
          ]);
      blocTest(
          'When failure, emits [DiscoveryWaiting, DiscoveryFetchingException]',
          build: () {
            when(usersRepository.getUsersByDiscoverySettings(any,
                    location: anyNamed('location')))
                .thenThrow(FirebaseException(
                    plugin: 'plugin', message: exceptionMessage));
            when(usersRepository.getUserRejections(any))
                .thenAnswer((_) async => rejectedUsersIds);
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(FetchAndFilterUsers(user: user)),
          expect: [
            DiscoveryWaiting(),
            DiscoveryFetchingException(message: exceptionMessage),
          ]);
    });
    group('AcceptUser -', () {
      final usersAfterAcceptance = [
        User(
            id: '4',
            name: 'Stacy',
            birthDate: DateTime(1998, 01, 01),
            gender: Gender.Woman),
      ];
      blocTest(
          'When successful, emits [DiscoveryWaiting, DiscoveryUsersFetched(updated)]',
          build: () {
            when(usersRepository.acceptUser(
                    acceptingUid: anyNamed('acceptingUid'),
                    acceptance: anyNamed('acceptance')))
                .thenAnswer((_) async => null);
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(
              AcceptUser(remainingUsers, acceptingUid: 'aa', acceptedUid: '2')),
          expect: [
            DiscoveryWaiting(),
            DiscoveryUsersFetched(usersAfterAcceptance),
          ]);
      blocTest(
          'When failure, emits [DiscoveryWaiting, DiscoveryActionException, DiscoveryUsersFetched(notUpdated)]',
          build: () {
            when(usersRepository.acceptUser(
                    acceptingUid: anyNamed('acceptingUid'),
                    acceptance: anyNamed('acceptance')))
                .thenThrow(FirebaseException(
                    plugin: 'plugin', message: exceptionMessage));
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(
              AcceptUser(remainingUsers, acceptingUid: 'aa', acceptedUid: '2')),
          expect: [
            DiscoveryWaiting(),
            DiscoveryActionException(message: exceptionMessage),
            DiscoveryUsersFetched(remainingUsers),
          ]);
    });
    group('RejectUser -', () {
      final usersAfterRejection = [
        User(
            id: '4',
            name: 'Stacy',
            birthDate: DateTime(1998, 01, 01),
            gender: Gender.Woman),
      ];
      blocTest(
          'When successful, emits [DiscoveryWaiting, DiscoveryUsersFetched(updated)]',
          build: () {
            when(usersRepository.rejectUser(
                    rejectingUid: anyNamed('rejectingUid'),
                    rejection: anyNamed('rejection')))
                .thenAnswer((_) async => null);
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(
              RejectUser(remainingUsers, rejectingUid: 'aa', rejectedUid: '2')),
          expect: [
            DiscoveryWaiting(),
            DiscoveryUsersFetched(usersAfterRejection),
          ]);
      blocTest(
          'When failure, emits [DiscoveryWaiting, DiscoveryActionException, DiscoveryUsersFetched(updated)]',
          build: () {
            when(usersRepository.rejectUser(
                    rejectingUid: anyNamed('rejectingUid'),
                    rejection: anyNamed('rejection')))
                .thenThrow(FirebaseException(
                    plugin: 'plugin', message: exceptionMessage));
            return DiscoveryBloc(usersRepository);
          },
          act: (bloc) => bloc.add(
              RejectUser(remainingUsers, rejectingUid: 'aa', rejectedUid: '2')),
          expect: [
            DiscoveryWaiting(),
            DiscoveryActionException(message: exceptionMessage),
            DiscoveryUsersFetched(remainingUsers),
          ]);
    });
  });
}
