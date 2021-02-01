import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final UsersRepository _repository;
  final AuthenticationRepository _authRepository;

  CurrentUserCubit(this._repository, this._authRepository)
      : super(CurrentUserInitial());

  Future<void> updateUser({User updatedUser, User oldUser}) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.updateUser(updatedUser);
      emit(CurrentUserReady(user: updatedUser));
    } catch (err) {
      emit(CurrentUserError(user: oldUser));
    }
  }

  Future<void> createUser(User user) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.createUser(user);
      emit(CurrentUserProfileIncomplete(user: user));
    } catch (err) {
      emit(CurrentUserError());
    }
  }

  Future<void> checkIfProfileIsComplete() async {
    emit(CurrentUserWaiting());

    try {
      final user = await _fetchUserData();
      if (user.name == null) {
        emit(CurrentUserProfileIncomplete(user: user));
      } else {
        emit(CurrentUserReady(user: user));
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
