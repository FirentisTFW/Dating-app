import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

  Future<String> createConversation(
      {@required String userId, @required String matchedUserId}) async {
    List<ConversationOverview> conversations;
    if (state is ConversationsFetched) {
      final currentState = state as ConversationsFetched;
      conversations = currentState.conversations;
    }

    emit(ConversationsWaiting());

    final conversation = ConversationBase(
      conversationId: userId + matchedUserId,
      userIds: [userId, matchedUserId],
      date: DateTime.now(),
    );

    try {
      await _conversationsRepository.createConversation(conversation);
      emit(ConversationsConversationCreated());
      if (conversations != null) {
        emit(ConversationsFetched(conversations));
        return conversation.conversationId;
      }
      emit(ConversationsInitial());
      return null;
    } catch (err) {
      emit(ConversationsError());
      return null;
    }
  }
}
