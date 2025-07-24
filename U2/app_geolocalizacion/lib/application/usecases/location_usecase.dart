import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/location_entity.dart';

class LocationUseCase {
  final LocationRepositoryImpl repository;

  LocationUseCase(this.repository);

  Future<LocationEntity> getLocation() => repository.getLocation();

  Stream<LocationEntity> watchLocation() => repository.watchLocation();
}
