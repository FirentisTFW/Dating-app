import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final UsersRepository _repository;

  CurrentUserCubit(this._repository) : super(CurrentUserInitial());

  Future<void> updateUser({User updatedUser, User oldUser}) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.updateUser(
          documentId: updatedUser.id, data: updatedUser);
      emit(CurrentUserReady(user: updatedUser));
    } catch (err) {
      emit(CurrentUserError(user: oldUser));
    }
  }

  Future<void> createUser(User user) async {
    emit(CurrentUserWaiting());

    try {
      await _repository.createUser(user);
      emit(CurrentUserReady(user: user));
    } catch (err) {
      emit(CurrentUserError());
    }
  }
}
