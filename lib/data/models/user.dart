import 'dart:convert';

import 'package:Dating_app/data/models/simple_location.dart';
import 'package:flutter/material.dart';

import 'enums.dart';
import 'extended_enums.dart';

class User {
  final String id;
  final String name;
  final DateTime birthDate;
  final Gender gender;
  final String caption;
  final SimpleLocation location;

  User({
    @required this.id,
    @required this.name,
    @required this.birthDate,
    @required this.gender,
    this.caption,
    this.location,
  });

  // JSON AND MAP SERIALIZATION

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'gender': GenderExtension.toMap(gender),
      'caption': caption,
      'location': location?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'],
      name: map['name'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      gender: GenderExtension.fromMap(map['gender']),
      caption: map['caption'],
      location: SimpleLocation.fromMap(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, birthDate: $birthDate, gender: $gender, caption: $caption, location: $location)';
  }
}
