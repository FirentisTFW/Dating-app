import 'package:flutter/material.dart';

import 'enums.dart';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final Gender gender;
  final String caption;
  final SimpleLocation location;

  User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.birthDate,
    @required this.gender,
    @required this.caption,
    @required this.location,
  });
}

class SimpleLocation {
  final double latitude;
  final double longitude;

  SimpleLocation({@required this.latitude, @required this.longitude});
}
