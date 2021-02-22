import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
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
      blocTest('When failure, emits [MatchesWaiting, MatchesError]',
          build: () {
            when(usersRepository.getUserMatches(any))
                .thenThrow(Exception('An error occured'));
            return MatchesCubit(usersRepository);
          },
          act: (cubit) => cubit.fetchMatches('userId'),
          expect: [
            MatchesWaiting(),
            MatchesError(),
          ]);
    });
  });
}
