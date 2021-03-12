import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/conversation_base.dart';
import 'package:Dating_app/data/models/message.dart';

class ConversationsRepository {
  final _firestoreProvider = locator<FirestoreProvider>();

  Future createConversation(ConversationBase conversation) async =>
      await _firestoreProvider.createConversation(conversation.toMap());

  Future sendMessage(String conversationId, Message message) async =>
      await _firestoreProvider.sendMessage(conversationId, message.toMap());

  Future getMessagesRef(String conversationId) async =>
      await _firestoreProvider.getMessagesRef(conversationId);

  Future<void> markLastMessageAsRead(
          String userId, String conversationId) async =>
      await _firestoreProvider.markLastMessageAsRead(userId, conversationId);
}
