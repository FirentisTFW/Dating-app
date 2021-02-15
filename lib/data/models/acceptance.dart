import 'dart:convert';

import 'package:flutter/foundation.dart';

class Acceptance {
  final String userId;
  final DateTime date;

  Acceptance({@required this.userId, @required this.date});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory Acceptance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Acceptance(
      userId: map['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Acceptance.fromJson(String source) =>
      Acceptance.fromMap(json.decode(source));
}
