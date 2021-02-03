part of 'current_user_cubit.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object> get props => [];
}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserWaiting extends CurrentUserState {}

abstract class CurrentUserWithUserInstance extends CurrentUserState {
  /// Extendable class which stores user instance
  final User user;

  CurrentUserWithUserInstance(this.user);

  @override
  List<Object> get props => [user];
}

class CurrentUserReady extends CurrentUserWithUserInstance {
  /// Profile complete, no errors occured
  CurrentUserReady(user) : super(user);
}

class CurrentUserProfileIncomplete extends CurrentUserWithUserInstance {
  /// Profile incomplete - it is missing either personal data (name, birthDate etc.) or searching criteria
  CurrentUserProfileIncomplete(user) : super(user);
}

class CurrentUserError extends CurrentUserWithUserInstance {
  final String message;

  CurrentUserError({user, this.message}) : super(user);

  @override
  List<Object> get props => [message];
}
