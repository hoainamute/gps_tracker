import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../viewmodels/location_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/location_service.dart';
import '../../data/location_repository.dart';
import '../../domain/location_usecase.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  LocationPageState createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  late GpsViewModel viewModel;
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    viewModel = GpsViewModel(
      LocationUseCase(LocationRepository(LocationService())),
    );

    requestLocationPermission();
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    // Start the timer to fetch location if permission is granted
    if (status.isGranted) {
      fetchLocation();
      locationTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
        fetchLocation();
      });
    } else {
      viewModel.setErrorMessage('Location permission is required to get GPS data.');
    }
  }

  void fetchLocation() async {
    try {
      // Define the location settings
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 30),
      );

      // Fetch the current position using the specified settings
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      viewModel.updatePosition(position);
    } catch (e) {
      viewModel.setErrorMessage('Error retrieving location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GPS Tracker'),
        ),
        body: Consumer<GpsViewModel>(
          builder: (context, model, child) {
            if (model.errorMessage != null) {
              return Center(child: Text(model.errorMessage!));
            }
            if (model.currentPosition != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lat: ${model.currentPosition!.latitude}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Long: ${model.currentPosition!.longitude}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Text(
                    //   'Accuracy: ${model.currentPosition!.accuracy} m',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Text(
                      'Altitude: ${model.currentPosition!.altitude} m',
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Text(
                    //   'Heading: ${model.currentPosition!.heading}°',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Text(
                      'Speed: ${model.currentPosition!.speed} m/s',
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Text(
                    //   'Speed Accuracy: ${model.currentPosition!.speedAccuracy} m/s',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Text(
                      'Timestamp: ${model.currentPosition!.timestamp}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
