import 'dart:convert';

import 'package:geoflutterfire/geoflutterfire.dart';

class CustomLocation extends GeoFirePoint {
  CustomLocation({double latitude, double longitude})
      : super(latitude, longitude);

  factory CustomLocation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomLocation(
      latitude: map['geopoint'].latitude,
      longitude: map['geopoint'].longitude,
    );
  }

  factory CustomLocation.fromJson(String source) =>
      CustomLocation.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomLocation &&
        o.latitude == latitude &&
        o.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'CustomLocation(latitude: $latitude, longitude: $longitude)';
  }
}
