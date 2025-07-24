import '../../domain/entities/location_entity.dart';
import '../datasources/location_datasource.dart';
import 'dart:async';

class LocationRepositoryImpl {
  final LocationDataSource dataSource;
  String? _lastAddress;
  DateTime? _lastAddressTime;
  final Duration _addressCacheDuration = const Duration(minutes: 5);

  LocationRepositoryImpl(this.dataSource);

  Future<LocationEntity> getLocation() async {
    final pos = await dataSource.getCurrentPosition();
    
    // Use cached address if available and recent
    String? address = await _getAddressWithCache(pos.latitude, pos.longitude);
    
    return LocationEntity(
      latitude: pos.latitude, 
      longitude: pos.longitude,
      address: address,
      accuracy: pos.accuracy,
    );
  }

  Stream<LocationEntity> watchLocation() {
    return dataSource.watchPosition().asyncMap((pos) async {
      // Use cached address if available and recent
      String? address = await _getAddressWithCache(pos.latitude, pos.longitude);
      
      return LocationEntity(
        latitude: pos.latitude, 
        longitude: pos.longitude,
        address: address,
        accuracy: pos.accuracy,
      );
    });
  }
  
  // Implement address caching to reduce geocoding API calls
  Future<String?> _getAddressWithCache(double latitude, double longitude) async {
    // Check if we have a cached address that's not too old
    if (_lastAddress != null && _lastAddressTime != null) {
      final now = DateTime.now();
      if (now.difference(_lastAddressTime!) < _addressCacheDuration) {
        return _lastAddress;
      }
    }
    
    // Get fresh address
    final address = await dataSource.getAddressFromCoordinates(latitude, longitude);
    
    // Update cache
    if (address != null) {
      _lastAddress = address;
      _lastAddressTime = DateTime.now();
    }
    
    return address;
  }
}
