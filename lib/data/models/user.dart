import 'dart:convert';

import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'enums.dart';
import 'extended_enums.dart';

class User extends Equatable {
  final String id;
  final String name;
  final DateTime birthDate;
  final Gender gender;
  final String caption;
  final CustomLocation location;
  final DiscoverySettings discoverySettings;

  User({
    @required this.id,
    @required this.name,
    @required this.birthDate,
    @required this.gender,
    this.caption,
    this.location,
    this.discoverySettings,
  });

  int getAge() {
    final currentDate = DateTime.now();
    if (birthDate.month < currentDate.month) {
      return currentDate.year - birthDate.year;
    } else if (birthDate.month == currentDate.month &&
        birthDate.day <= currentDate.day) {
      return currentDate.year - birthDate.year;
    }
    return currentDate.year - birthDate.year - 1;
  }

  // JSON AND MAP SERIALIZATION

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'gender': GenderExtension.toMap(gender),
      'caption': caption,
      'location': location.data,
      'discoverySettings': discoverySettings?.toMap(),
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
      location: CustomLocation.fromMap(map['location']),
      discoverySettings: DiscoverySettings.fromMap(map['discoverySettings']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, birthDate: $birthDate, gender: $gender, caption: $caption, location: $location, discoverySettings: $discoverySettings)';
  }

  User copyWith({
    String id,
    String name,
    DateTime birthDate,
    Gender gender,
    String caption,
    CustomLocation location,
    DiscoverySettings discoverySettings,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      discoverySettings: discoverySettings ?? this.discoverySettings,
    );
  }

  @override
  List<Object> get props =>
      [id, name, birthDate, gender, caption, location, discoverySettings];
}
