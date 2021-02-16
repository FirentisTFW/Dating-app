import 'dart:convert';

import 'package:flutter/foundation.dart';

abstract class DiscoveryActionInstance {
  final String userId;
  final DateTime date;

  DiscoveryActionInstance({@required this.userId, @required this.date});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());
}

class Acceptance extends DiscoveryActionInstance {
  Acceptance({@required userId, @required date})
      : super(userId: userId, date: date);

  factory Acceptance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Acceptance(
      userId: map['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  factory Acceptance.fromJson(String source) =>
      Acceptance.fromMap(json.decode(source));
}

class Rejection extends DiscoveryActionInstance {
  Rejection({@required userId, @required date})
      : super(userId: userId, date: date);

  factory Rejection.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Rejection(
      userId: map['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  factory Rejection.fromJson(String source) =>
      Rejection.fromMap(json.decode(source));
}
