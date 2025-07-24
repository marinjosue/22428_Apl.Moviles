import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsService {
  CameraPosition posicionInicial(double lat, double lng) {
    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 13,
    );
  }
}
