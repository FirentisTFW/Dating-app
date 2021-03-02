import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:Dating_app/data/models/conversation_base.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';

part 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final UsersRepository _usersRepository;
  final ConversationsRepository _conversationsRepository;

  ConversationsCubit(this._usersRepository, this._conversationsRepository)
      : super(ConversationsInitial());

  Future<void> fetchConversations(String userId) async {
    emit(ConversationsWaiting());

    try {
      final conversations = await _usersRepository.getUserConversations(userId);
      emit(ConversationsFetched(conversations));
    } catch (err) {
      emit(ConversationsError());
    }
  }

  Future<String> createConversation(ConversationBase conversation) async {
    List<ConversationOverview> conversations;
    if (state is ConversationsFetched) {
      final currentState = state as ConversationsFetched;
      conversations = currentState.conversations;
    }

    emit(ConversationsWaiting());

    try {
      await _conversationsRepository.createConversation(conversation);
      emit(ConversationsConversationCreated());
      if (conversations != null) {
        emit(ConversationsFetched(conversations));
        return conversation.conversationId;
      }
      emit(ConversationsInitial());
      return conversation.conversationId;
    } catch (err) {
      emit(ConversationsError());
      return null;
    }
  }
}
