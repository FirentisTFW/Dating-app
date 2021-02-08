import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future getCurrentLocation() async => await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
