import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    } on FirebaseException catch (err) {
      emit(MatchesException(message: err.message));
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
    } on FirebaseException catch (err) {
      emit(MatchesException(message: err.message));
      emit(MatchesFetched(currentMatches));
    }
  }
}
