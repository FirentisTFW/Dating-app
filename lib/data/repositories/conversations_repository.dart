import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/models/conversation_base.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationsRepository {
  final _firestoreProvider = locator<FirestoreProvider>();

  Future<void> createConversation(ConversationBase conversation) async =>
      await _firestoreProvider.createConversation(conversation.toMap());

  Future<void> sendMessage(String conversationId, Message message) async =>
      await _firestoreProvider.sendMessage(conversationId, message.toMap());

  Future<CollectionReference> getMessagesRef(String conversationId) async =>
      await _firestoreProvider.getMessagesRef(conversationId);

  Future<void> markLastMessageAsRead(
          String userId, String conversationId) async =>
      await _firestoreProvider.markLastMessageAsRead(userId, conversationId);
}
