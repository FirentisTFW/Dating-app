part of 'discovery_bloc.dart';

abstract class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends DiscoveryEvent {
  final DiscoverySettings discoverySettings;
  final CustomLocation currentLocation;

  const FetchUsers(this.discoverySettings, this.currentLocation);

  @override
  List<Object> get props => [discoverySettings];
}
