part of 'discovery_bloc.dart';

abstract class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object> get props => [];
}

class FetchAndFilterUsers extends DiscoveryEvent {
  final User user;

  const FetchAndFilterUsers({@required this.user});

  @override
  List<Object> get props => [user];
}

class AcceptUser extends DiscoveryEvent {
  final List<User> users;
  final String acceptingUid;
  final String acceptedUid;

  AcceptUser(this.users,
      {@required this.acceptingUid, @required this.acceptedUid});

  @override
  List<Object> get props => [acceptingUid, acceptedUid];
}
