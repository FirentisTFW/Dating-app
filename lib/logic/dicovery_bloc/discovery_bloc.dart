import 'dart:async';

import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'discovery_event.dart';
part 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final UsersRepository _usersRepository;

  DiscoveryBloc(this._usersRepository) : super(DiscoveryInitial());

  @override
  Stream<DiscoveryState> mapEventToState(
    DiscoveryEvent event,
  ) async* {
    yield DiscoveryWaiting();

    if (event is FetchUsers) {
      try {
        final users = await _usersRepository.getUsersByDiscoverySettings(
            event.discoverySettings,
            location: event.currentLocation);
        yield DiscoveryUsersFetched(users);
      } catch (err) {
        yield DiscoveryError();
      }
    }
  }
}
