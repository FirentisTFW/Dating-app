import 'dart:convert';

import 'package:Dating_app/data/models/message.dart';
import 'package:flutter/foundation.dart';

class Conversation {
  final String userId;
  final String userName;
  final Message lastMessage;

  Conversation({
    @required this.userId,
    @required this.userName,
    @required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Conversation(
      userId: map['userId'],
      userName: map['userName'],
      lastMessage: Message.fromMap(map['lastMessage']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));
}
