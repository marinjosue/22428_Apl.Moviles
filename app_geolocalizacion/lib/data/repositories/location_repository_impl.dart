import '../../domain/entities/location_entity.dart';
import '../datasources/location_datasource.dart';

class LocationRepositoryImpl {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  Future<LocationEntity> getLocation() async {
    final pos = await dataSource.getCurrentPosition();
    return LocationEntity(latitude: pos.latitude, longitude: pos.longitude);
  }

  Stream<LocationEntity> watchLocation() {
    return dataSource.watchPosition().map(
      (pos) => LocationEntity(latitude: pos.latitude, longitude: pos.longitude),
    );
  }
}
