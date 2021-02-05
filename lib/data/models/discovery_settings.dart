import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'enums.dart';
import 'extended_enums.dart';

class DiscoverySettings {
  final Gender gender;
  final int ageMin;
  final int ageMax;
  final int distance;

  DiscoverySettings({
    @required this.gender,
    @required this.ageMin,
    @required this.ageMax,
    @required this.distance,
  });

  // JSON AND MAP SERIALIZATION

  Map<String, dynamic> toMap() {
    return {
      'gender': GenderExtension.toMap(gender),
      'ageMin': ageMin,
      'ageMax': ageMax,
      'distance': distance,
    };
  }

  factory DiscoverySettings.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DiscoverySettings(
      gender: GenderExtension.fromMap(map['gender']),
      ageMin: map['ageMin'],
      ageMax: map['ageMax'],
      distance: map['distance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscoverySettings.fromJson(String source) =>
      DiscoverySettings.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DiscoverySettings(gender: $gender, ageMin: $ageMin, ageMax: $ageMax, distance: $distance)';
  }
}
