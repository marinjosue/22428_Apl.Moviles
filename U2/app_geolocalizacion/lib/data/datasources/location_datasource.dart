import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationDataSource {
  StreamSubscription<Position>? _positionSubscription;
  final _locationController = StreamController<Position>.broadcast();
  bool _isInitialized = false;
  
  // Cache to minimize geocoding operations
  final Map<String, String> _addressCache = {};
  
  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    
    return true;
  }

  Future<Position> getCurrentPosition() async {
    try {
      await _checkPermission();
      // Use lower accuracy for emulator
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium
      );
    } catch (e) {
      // Ubicación por defecto: Sangolquí
      return Position(
        latitude: -0.3317,
        longitude: -78.4448,
        timestamp: DateTime.now(),
        accuracy: 50,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

 Stream<Position> watchPosition() async* {
    try {
      await _checkPermission();
      yield* Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 50,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      // Emitir Sangolquí si falla
      yield Position(
        latitude: -0.3317,
        longitude: -78.4448,
        timestamp: DateTime.now(),
        accuracy: 50,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }
  
  void _initLocationStream() async {
    try {
      await _checkPermission();
      
      // Use lower frequency and accuracy for emulator
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 50,  // Only trigger if moved 50 meters
          timeLimit: Duration(seconds: 10),  // Limit how often we get updates
        ),
      ).listen(
        (position) => _locationController.add(position),
        onError: (e) => _locationController.addError(e),
      );
    } catch (e) {
      _locationController.addError(e);
    }
  }

  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    // Create a cache key with reduced precision to increase cache hits
    final cacheKey = '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';
    
    // Return cached address if available
    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey];
    }
    
    // Reduce geocoding operations on emulator
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, 
        longitude,
        localeIdentifier: 'es_ES',  // Use Spanish locale
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        
        // Build a simplified address string
        final addressParts = <String>[];
        
        if (place.thoroughfare?.isNotEmpty ?? false) {
          addressParts.add(place.thoroughfare!);
        }
        
        if (place.locality?.isNotEmpty ?? false) {
          addressParts.add(place.locality!);
        }
        
        if (place.country?.isNotEmpty ?? false) {
          addressParts.add(place.country!);
        }
        
        final address = addressParts.join(', ');
        
        // Cache the result
        _addressCache[cacheKey] = address;
        
        return address;
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    
    return null;
  }
  
  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
  }
}
