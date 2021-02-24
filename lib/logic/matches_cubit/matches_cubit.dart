import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  final UsersRepository _usersRepository;

  MatchesCubit(this._usersRepository) : super(MatchesInitial());

  Future<void> fetchMatches(String userId) async {
    emit(MatchesWaiting());

    try {
      final matches = await _usersRepository.getUserMatches(userId);
      emit(MatchesFetched(matches));
    } catch (err) {
      emit(MatchesError());
    }
  }

  Future<void> unmatchUser(String unmatchingUid, String unmatchedUid) async {
    final currentState = state as MatchesFetched;
    final currentMatches = currentState.matches;

    emit(MatchesWaiting());

    try {
      await _usersRepository.unmatchUser(unmatchingUid, unmatchedUid);
      final remainingMatches = currentMatches
          .where((match) => match.userId != unmatchedUid)
          .toList();
      emit(MatchesFetched(remainingMatches));
    } catch (err) {
      emit(MatchesError());
      emit(MatchesFetched(currentMatches));
    }
  }
}
