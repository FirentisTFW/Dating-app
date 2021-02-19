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
}
