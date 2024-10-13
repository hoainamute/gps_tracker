import 'location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  final LocationService locationService;

  LocationRepository(this.locationService);

  Future<Position> fetchCurrentLocation() async {
    return await locationService.getCurrentLocation();
  }
}
