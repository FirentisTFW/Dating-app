import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ConversationsRepository _conversationsRepository;

  MessagesCubit(this._conversationsRepository) : super(MessagesInitial());

  Future<void> getMessagesRef(String conversationId) async {
    emit(MessagesWaiting());

    try {
      final messagesRefrerence =
          await _conversationsRepository.getMessagesRef(conversationId);
      emit(MessagesReferenceFetched(messagesRefrerence));
    } catch (err) {
      emit(MessagesErrorFetching());
    }
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    CollectionReference messagesReference;
    if (state is MessagesReferenceFetched) {
      final currentState = state as MessagesReferenceFetched;
      messagesReference = currentState.messagesRefrerence;
    }

    try {
      await _conversationsRepository.sendMessage(conversationId, message);
      emit(MessagesMessageSent());
    } catch (err) {
      emit(MessagesErrorSending());
    }
    if (messagesReference != null) {
      emit(MessagesReferenceFetched(messagesReference));
    }
  }
}
