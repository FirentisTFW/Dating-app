part of 'discovery_bloc.dart';

abstract class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object> get props => [];
}

class DiscoveryInitial extends DiscoveryState {}

class DiscoveryWaiting extends DiscoveryState {
  final List<User> users;

  const DiscoveryWaiting({this.users});

  @override
  List<Object> get props => [users];
}

class DiscoveryUsersFetched extends DiscoveryState {
  final List<User> users;

  const DiscoveryUsersFetched(this.users);

  @override
  List<Object> get props => [users];
}

abstract class DiscoveryException extends DiscoveryState {
  final List<User> users;
  final String message;

  const DiscoveryException({this.users, this.message});

  @override
  List<Object> get props => [users, message];
}

class DiscoveryFetchingException extends DiscoveryException {
  const DiscoveryFetchingException({String message}) : super(message: message);
}

class DiscoveryActionException extends DiscoveryException {
  const DiscoveryActionException({String message}) : super(message: message);
}
