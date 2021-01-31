part of 'current_user_cubit.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object> get props => [];
}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserWaiting extends CurrentUserState {}

class CurrentUserReady extends CurrentUserState {
  final User user;

  CurrentUserReady({this.user});
}

class CurrentUserError extends CurrentUserState {
  final String message;
  final User user;

  CurrentUserError({this.user, this.message});
}
