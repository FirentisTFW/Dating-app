part of 'current_user_cubit.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object> get props => [];
}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserWaiting extends CurrentUserState {}

class CurrentUserLocationReceived extends CurrentUserState {
  final CustomLocation location;

  CurrentUserLocationReceived(this.location);

  @override
  List<Object> get props => [location];
}

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
  final ProfileStatus profileStatus;

  CurrentUserProfileIncomplete({@required user, @required this.profileStatus})
      : super(user);

  @override
  List<Object> get props => [profileStatus];
}

class CurrentUserError extends CurrentUserWithUserInstance {
  final String message;

  CurrentUserError({user, this.message}) : super(user);

  @override
  List<Object> get props => [message];
}
