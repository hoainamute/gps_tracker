import 'package:flutter/material.dart';
import '../../domain/location_usecase.dart';
import 'package:geolocator/geolocator.dart';

class GpsViewModel extends ChangeNotifier {
  final LocationUseCase locationUseCase;

  Position? _currentPosition;
  String? _errorMessage;

  GpsViewModel(this.locationUseCase);

  Position? get currentPosition => _currentPosition;
  String? get errorMessage => _errorMessage;

 void updatePosition(Position position) {
    _currentPosition = position;
    _errorMessage = null; // Reset any error message
    notifyListeners(); // Notify listeners to update UI
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> fetchLocation() async {
    try {
      _currentPosition = await locationUseCase.execute();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error retrieving location';
    }
    notifyListeners();
  }
}
