import 'dart:convert';

import 'package:Dating_app/data/models/message.dart';
import 'package:flutter/foundation.dart';

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
      'usersId': userId,
      'userName': userName,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory ConversationOverview.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationOverview(
      conversationId: map['conversationId'],
      userId: map['usersId'],
      userName: map['userName'],
      lastMessage: Message.fromMap(map['lastMessage']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationOverview.fromJson(String source) =>
      ConversationOverview.fromMap(json.decode(source));
}
