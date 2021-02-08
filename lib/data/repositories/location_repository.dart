import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/location_provider.dart';
import 'package:Dating_app/data/models/simple_location.dart';

class LocationRepository {
  final _locationProvider = locator<LocationProvider>();

  Future getCurrentLocation() async {
    final location = await _locationProvider.getCurrentLocation();
    return SimpleLocation(
        latitude: location.latitude, longitude: location.longitude);
  }
}
