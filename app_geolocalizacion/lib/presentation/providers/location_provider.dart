import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../application/usecases/location_usecase.dart';
import '../../../../../domain/entities/location_entity.dart';

class LocationProvider extends ChangeNotifier {
  final LocationUseCase useCase;
  StreamSubscription<LocationEntity>? _locationSubscription;

  LocationEntity? _location;
  LocationEntity? get location => _location;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  LocationProvider(this.useCase);
  
  void startListening() {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Get initial location quickly
      useCase.getLocation().then(
        (loc) {
          _location = loc;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error inicial: $e';
          _isLoading = false;
          notifyListeners();
        }
      );
      
      // Cancel any existing subscription
      _locationSubscription?.cancel();
      
      // Start listening with lower frequency
      _locationSubscription = useCase.watchLocation().listen(
        (loc) {
          _location = loc;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error: $e';
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
