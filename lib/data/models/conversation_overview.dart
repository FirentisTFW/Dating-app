import 'dart:convert';

import 'package:Dating_app/data/models/message.dart';
import 'package:flutter/foundation.dart';

class ConversationOverview {
  final String conversationId;
  final String userId;
  final String userName;
  final Message lastMessage;
  final bool lastMessageRead;

  ConversationOverview({
    @required this.conversationId,
    @required this.userId,
    @required this.userName,
    @required this.lastMessage,
    @required this.lastMessageRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'userName': userName,
      'lastMessage': lastMessage?.toMap(),
      'lastMessageRead': lastMessageRead,
    };
  }

  factory ConversationOverview.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationOverview(
      conversationId: map['conversationId'],
      userId: map['userId'],
      userName: map['userName'],
      lastMessage: Message.fromMap(map['lastMessage']),
      lastMessageRead: map['lastMessageRead'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationOverview.fromJson(String source) =>
      ConversationOverview.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationOverview(conversationId: $conversationId, userId: $userId, userName: $userName, lastMessage: $lastMessage, lastMessageRead: $lastMessageRead)';
  }
}
