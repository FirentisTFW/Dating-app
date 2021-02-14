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
