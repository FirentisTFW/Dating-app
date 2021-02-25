import 'dart:convert';

import 'package:flutter/material.dart';

class Message {
  final String userId;
  final String content;
  final DateTime date;
  final bool read;

  Message({
    @required this.userId,
    @required this.content,
    @required this.date,
    @required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'date': date?.millisecondsSinceEpoch,
      'read': read,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
      userId: map['userId'],
      content: map['content'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      read: map['read'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
