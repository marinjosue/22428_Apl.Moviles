class LocationEntity {
  final double latitude;
  final double longitude;
  final String? address;
  final double? accuracy;

  LocationEntity({
    required this.latitude, 
    required this.longitude,
    this.address,
    this.accuracy,
  });
}
