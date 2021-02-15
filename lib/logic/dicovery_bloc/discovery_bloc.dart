import 'dart:async';

import 'package:Dating_app/data/models/acceptance.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

    if (event is FetchAndFilterUsers) {
      try {
        final fetchedUsers = await _usersRepository.getUsersByDiscoverySettings(
            event.user.discoverySettings,
            location: event.user.location);
        final rejectedUsersIds =
            await _usersRepository.getUserRejections(event.user.id);
        final unrejectedUsers = fetchedUsers
            .where((user) =>
                !rejectedUsersIds.any((rejectedId) => rejectedId == user.id))
            .toList();
        yield DiscoveryUsersFetched(unrejectedUsers);
      } catch (err) {
        yield DiscoveryError();
      }
    } else if (event is AcceptUser) {
      try {
        await _usersRepository.acceptUser(
            acceptingUid: event.acceptingUid,
            acceptance:
                Acceptance(userId: event.acceptedUid, date: DateTime.now()));
        final remainingUsers =
            event.users.where((u) => u.id != event.acceptedUid).toList();
        yield DiscoveryUsersFetched(remainingUsers);
      } catch (err) {
        yield DiscoveryError();
      }
    }
  }
}
