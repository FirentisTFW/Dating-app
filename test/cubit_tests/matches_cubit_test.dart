import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsersRepositoryMock extends Mock implements UsersRepository {}

void main() {
  UsersRepositoryMock usersRepository;

  final matches = [
    UserMatch(
      userId: 'abc1',
      name: 'Jessica',
      birthDate: DateTime(1995, 01, 22),
      date: DateTime(2021, 02, 20),
    ),
    UserMatch(
      userId: 'cde2',
      name: 'Stacy',
      birthDate: DateTime(1994, 07, 01),
      date: DateTime(2021, 02, 20),
    ),
  ];
  final exceptionMessage = 'An exception occured';

  group('MatchesCubitTest -', () {
    setUp(() {
      usersRepository = UsersRepositoryMock();
    });
    group('fetchMatches -', () {
      blocTest('When successful, emits [MatchesWaiting, MatchesFetched]',
          build: () {
            when(usersRepository.getUserMatches(any))
                .thenAnswer((_) async => matches);
            return MatchesCubit(usersRepository);
          },
          act: (cubit) => cubit.fetchMatches('userId'),
          expect: [
            MatchesWaiting(),
            MatchesFetched(matches),
          ]);
      blocTest('When failure, emits [MatchesWaiting, MatchesException]',
          build: () {
            when(usersRepository.getUserMatches(any)).thenThrow(
                FirebaseException(plugin: 'plugin', message: exceptionMessage));
            return MatchesCubit(usersRepository);
          },
          act: (cubit) => cubit.fetchMatches('userId'),
          expect: [
            MatchesWaiting(),
            MatchesException(message: exceptionMessage),
          ]);
    });
    group('unmatchUser -', () {
      final remainingMatches = [
        UserMatch(
          userId: 'abc1',
          name: 'Jessica',
          birthDate: DateTime(1995, 01, 22),
          date: DateTime(2021, 02, 20),
        ),
      ];
      blocTest(
          'When successful and matches were fetched before, emits [MatchesWaiting, MatchesFetched(remainingUsers)]',
          build: () {
        when(usersRepository.getUserMatches(any))
            .thenAnswer((_) async => matches);
        when(usersRepository.unmatchUser(any, any))
            .thenAnswer((_) async => null);

        return MatchesCubit(usersRepository);
      }, act: (cubit) async {
        await cubit.fetchMatches('userId');
        cubit.unmatchUser('unmatchingUid', 'cde2');
      }, skip: 2, expect: [
        MatchesWaiting(),
        MatchesFetched(remainingMatches),
      ]);
      blocTest(
          'When failure and matches were fetched before, emits [MatchesWaiting, MatchesException, MatchesFetched(oldMatched)]',
          build: () {
        when(usersRepository.getUserMatches(any))
            .thenAnswer((_) async => matches);
        when(usersRepository.unmatchUser(any, any)).thenThrow(
            FirebaseException(plugin: 'plugin', message: exceptionMessage));

        return MatchesCubit(usersRepository);
      }, act: (cubit) async {
        await cubit.fetchMatches('userId');
        cubit.unmatchUser('unmatchingUid', 'cde2');
      }, skip: 2, expect: [
        MatchesWaiting(),
        MatchesException(message: exceptionMessage),
        MatchesFetched(matches),
      ]);
    });
  });
}
