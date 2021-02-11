import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final UsersRepository _usersRepository;
  final AuthenticationRepository _authRepository;
  final LocationRepository _locationRepository;

  CurrentUserCubit(
      this._usersRepository, this._authRepository, this._locationRepository)
      : super(CurrentUserInitial());

  Future<void> updateUser({User updatedUser, User oldUser}) async {
    emit(CurrentUserWaiting());

    try {
      await _usersRepository.updateUser(updatedUser);
      emit(CurrentUserReady(updatedUser));
    } catch (err) {
      emit(CurrentUserError(user: oldUser));
    }
  }

  Future<void> createUser(User user) async {
    emit(CurrentUserWaiting());

    try {
      await _usersRepository.createUser(user);
      emit(CurrentUserProfileIncomplete(
          user: user, profileStatus: ProfileStatus.MissingDiscoverySettings));
    } catch (err) {
      emit(CurrentUserError());
    }
  }

  Future<void> updateDiscoverySettings(
      User user, DiscoverySettings discoverySettings) async {
    emit(CurrentUserWaiting());

    try {
      final userId = _authRepository.userId;
      await _usersRepository.updateDiscoverySettings(userId, discoverySettings);
      emit(CurrentUserReady(user));
    } catch (err) {
      emit(CurrentUserError(user: user));
    }
  }

  Future<void> getCurrentLocation() async {
    emit(CurrentUserWaiting());

    try {
      final currentLocation = await _locationRepository.getCurrentLocation();
      emit(CurrentUserLocationReceived(currentLocation));
    } catch (err) {
      emit(CurrentUserError(message: 'Check device location permissions'));
    }
  }

  Future<void> checkIfProfileIsComplete() async {
    emit(CurrentUserWaiting());

    try {
      final user = await _fetchUserData();

      if (user.name == null) {
        emit(CurrentUserProfileIncomplete(
            user: user, profileStatus: ProfileStatus.MissingPersonalData));
      } else if (user.discoverySettings == null) {
        emit(CurrentUserProfileIncomplete(
            user: user, profileStatus: ProfileStatus.MissingDiscoverySettings));
      } else {
        emit(CurrentUserReady(user));
      }
    } catch (err) {
      emit(CurrentUserError());
    }
  }

  Future<User> _fetchUserData() async {
    try {
      final uid = _authRepository.userId;
      final user = await _usersRepository.getUser(uid);
      return user;
    } catch (err) {
      rethrow;
    }
  }
}
