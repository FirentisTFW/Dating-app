import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:Dating_app/data/models/message.dart';

class ConversationOverview {
  final String conversationId;
  final String userId;
  final String userName;
  final Message lastMessage;

  ConversationOverview({
    @required this.conversationId,
    @required this.userId,
    @required this.userName,
    @required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'userName': userName,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory ConversationOverview.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationOverview(
      conversationId: map['conversationId'],
      userId: map['userId'],
      userName: map['userName'],
      lastMessage: Message.fromMap(map['lastMessage']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationOverview.fromJson(String source) =>
      ConversationOverview.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationOverview(conversationId: $conversationId, userId: $userId, userName: $userName, lastMessage: $lastMessage)';
  }
}
