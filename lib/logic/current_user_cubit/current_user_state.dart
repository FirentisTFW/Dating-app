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

/// Extendable class which stores user instance
abstract class CurrentUserWithUserInstance extends CurrentUserState {
  final User user;

  CurrentUserWithUserInstance(this.user);

  @override
  List<Object> get props => [user];
}

/// Profile complete, no errors occured
class CurrentUserReady extends CurrentUserWithUserInstance {
  CurrentUserReady(user) : super(user);
}

/// Profile incomplete - it is missing either personal data (name, birthDate etc.) or searching criteria
class CurrentUserProfileIncomplete extends CurrentUserWithUserInstance {
  final ProfileStatus profileStatus;

  CurrentUserProfileIncomplete({@required user, @required this.profileStatus})
      : super(user);

  @override
  List<Object> get props => [profileStatus];
}

abstract class CurrentUserFailure extends CurrentUserState {
  final String message;

  CurrentUserFailure({this.message});

  @override
  List<Object> get props => [message];
}

/// Failure which doesn't stop other actions -it's only a signal that something went wrong (i.e. updating user)
class CurrentUserLightFailure extends CurrentUserFailure {
  CurrentUserLightFailure({message}) : super(message: message);
}

/// Failure which prevents from taking next actions (i.e. creating user or checking if user's profile is complete -
/// user cannot go to matches page if he doesn't exists)
class CurrentUserHeavyFailure extends CurrentUserFailure {
  CurrentUserHeavyFailure({message}) : super(message: message);
}
