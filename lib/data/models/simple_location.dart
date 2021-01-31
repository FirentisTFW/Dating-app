import 'dart:convert';

import 'package:flutter/foundation.dart';

class SimpleLocation {
  final double latitude;
  final double longitude;

  SimpleLocation({@required this.latitude, @required this.longitude});

  // JSON AND MAP SERIALIZATION

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SimpleLocation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SimpleLocation(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleLocation.fromJson(String source) =>
      SimpleLocation.fromMap(json.decode(source));
}
