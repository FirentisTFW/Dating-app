part of 'matches_cubit.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class MatchesInitial extends MatchesState {}

class MatchesWaiting extends MatchesState {}

class MatchesFetched extends MatchesState {
  final List<UserMatch> matches;

  const MatchesFetched(this.matches);

  @override
  List<Object> get props => [matches];
}

class MatchesError extends MatchesState {
  final String message;

  const MatchesError({this.message});

  @override
  List<Object> get props => [message];
}
