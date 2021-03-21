import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position> getCurrentLocation() async =>
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
}
