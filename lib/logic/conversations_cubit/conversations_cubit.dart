import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final UsersRepository _usersRepository;

  ConversationsCubit(this._usersRepository) : super(ConversationsInitial());

  Future<void> fetchConversations(String userId) async {
    emit(ConversationsWaiting());

    try {
      final conversations = await _usersRepository.getUserConversations(userId);
      emit(ConversationsFetched(conversations));
    } catch (err) {
      emit(ConversationsError());
    }
  }
}
