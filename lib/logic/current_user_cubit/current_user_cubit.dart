import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final UsersRepository _repository;
  final AuthenticationRepository _authRepository;
  final PhotosRepository _photosRepository;

  CurrentUserCubit(
      this._repository, this._authRepository, this._photosRepository)
      : super(CurrentUserInitial());

  Future<void> updateUser({User updatedUser, User oldUser}) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.updateUser(updatedUser);
      emit(CurrentUserReady(updatedUser));
    } catch (err) {
      emit(CurrentUserError(user: oldUser));
    }
  }

  Future<void> createUser(User user) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.createUser(user);
      emit(CurrentUserProfileIncomplete(user));
    } catch (err) {
      emit(CurrentUserError());
    }
  }

  Future<void> uploadPhoto(User user, PickedFile photo) async {
    emit(CurrentUserWaiting());

    try {
      final userId = _authRepository.userId;
      await _photosRepository.uploadPhoto(photo, userId);
      emit(CurrentUserProfileIncomplete(user));
    } catch (err) {
      emit(CurrentUserError(user: user));
    }
  }

  Future<void> checkIfProfileIsComplete() async {
    emit(CurrentUserWaiting());

    try {
      final user = await _fetchUserData();

      if (user.name == null) {
        emit(CurrentUserProfileIncomplete(user));
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
      final user = await _repository.getUser(uid);
      return user;
    } catch (err) {
      rethrow;
    }
  }
}
