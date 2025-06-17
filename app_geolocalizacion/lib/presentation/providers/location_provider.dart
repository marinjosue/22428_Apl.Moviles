import 'package:flutter/material.dart';
import '../../../../../application/usecases/location_usecase.dart';
import '../../../../../domain/entities/location_entity.dart';

class LocationProvider extends ChangeNotifier {
  final LocationUseCase useCase;

  LocationEntity? _location;
  LocationEntity? get location => _location;

  void startListening() {
    useCase.watchLocation().listen((loc) {
      _location = loc;
      notifyListeners();
    });
  }

  LocationProvider(this.useCase);
}
