import '../data/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class LocationUseCase {
  final LocationRepository locationRepository;

  LocationUseCase(this.locationRepository);

  Future<Position> execute() async {
    return await locationRepository.fetchCurrentLocation();
  }
}
