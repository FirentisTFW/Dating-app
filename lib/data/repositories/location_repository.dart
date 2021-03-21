import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/location_provider.dart';
import 'package:Dating_app/data/models/custom_location.dart';

class LocationRepository {
  final _locationProvider = locator<LocationProvider>();

  Future<CustomLocation> getCurrentLocation() async {
    final location = await _locationProvider.getCurrentLocation();
    return CustomLocation(
        latitude: location.latitude, longitude: location.longitude);
  }
}
