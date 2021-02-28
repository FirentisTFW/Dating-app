import 'dart:convert';

import 'package:flutter/foundation.dart';

class ConversationBase {
  final String conversationId;
  final List<String> userIds;
  final DateTime date;

  ConversationBase({
    @required this.conversationId,
    @required this.userIds,
    @required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'userIds': userIds,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory ConversationBase.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationBase(
      conversationId: map['conversationId'],
      userIds: List<String>.from(map['userIds']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationBase.fromJson(String source) =>
      ConversationBase.fromMap(json.decode(source));
}
