import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserMatch extends Equatable {
  final String userId;
  final String name;
  final DateTime birthDate;
  final DateTime date;
  final String conversationId;

  UserMatch({
    @required this.userId,
    @required this.name,
    @required this.birthDate,
    @required this.date,
    this.conversationId,
  });

  @override
  List<Object> get props => [userId, name, birthDate, date];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'date': date?.millisecondsSinceEpoch,
      'conversationId': conversationId,
    };
  }

  factory UserMatch.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserMatch(
      userId: map['userId'],
      name: map['name'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      conversationId: map['conversationId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMatch.fromJson(String source) =>
      UserMatch.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
