import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Set the desired accuracy here
      distanceFilter: 10, // Minimum distance in meters for update
      timeLimit: const Duration(seconds: 30), // Optional timeout duration
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
