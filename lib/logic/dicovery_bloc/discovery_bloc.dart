import 'dart:async';

import 'package:Dating_app/data/models/acceptance_rejection.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      yield* _mapFetchAndFilterUsersToState(event);
    } else if (event is AcceptUser) {
      yield* _mapAcceptUserToState(event);
    } else if (event is RejectUser) {
      yield* _mapRejectUserToState(event);
    }
  }

  Stream<DiscoveryState> _mapFetchAndFilterUsersToState(
      FetchAndFilterUsers event) async* {
    try {
      final fetchedUsers = await _usersRepository.getUsersByDiscoverySettings(
          event.user.discoverySettings,
          location: event.user.location);
      final rejectedUsersIds =
          await _usersRepository.getUserRejections(event.user.id);
      final acceptedUsersIds =
          await _usersRepository.getUserAcceptances(event.user.id);
      final excludedUsersIds = rejectedUsersIds + acceptedUsersIds;

      final finalUsers = fetchedUsers
          .where((user) =>
              !excludedUsersIds.any((excludedId) => excludedId == user.id))
          .toList();
      yield DiscoveryUsersFetched(finalUsers);
    } on FirebaseException catch (err) {
      yield DiscoveryFetchingException(message: err.message);
    }
  }

  Stream<DiscoveryState> _mapAcceptUserToState(AcceptUser event) async* {
    try {
      await _usersRepository.acceptUser(
          acceptingUid: event.acceptingUid,
          acceptance:
              Acceptance(userId: event.acceptedUid, date: DateTime.now()));
      final remainingUsers =
          event.users.where((u) => u.id != event.acceptedUid).toList();
      yield DiscoveryUsersFetched(remainingUsers);
    } on FirebaseException catch (err) {
      yield DiscoveryActionException(message: err.message);
      yield DiscoveryUsersFetched(event.users);
    }
  }

  Stream<DiscoveryState> _mapRejectUserToState(RejectUser event) async* {
    try {
      await _usersRepository.rejectUser(
          rejectingUid: event.rejectingUid,
          rejection:
              Rejection(userId: event.rejectedUid, date: DateTime.now()));
      final remainingUsers =
          event.users.where((u) => u.id != event.rejectedUid).toList();
      yield DiscoveryUsersFetched(remainingUsers);
    } on FirebaseException catch (err) {
      yield DiscoveryActionException(message: err.message);
      yield DiscoveryUsersFetched(event.users);
    }
  }
}
