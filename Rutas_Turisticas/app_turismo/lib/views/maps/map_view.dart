import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/sitios_viewmodel.dart';
import '../../models/sitio_turistico.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sitiosViewModel = Provider.of<SitiosViewModel>(context);

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-0.002789, -78.455833),
          zoom: 11,
        ),
        markers: sitiosViewModel.sitios.map((SitioTuristico sitio) {
          return Marker(
            markerId: MarkerId(sitio.id),
            position: LatLng(sitio.latitud, sitio.longitud),
            infoWindow: InfoWindow(
              title: sitio.nombre,
              snippet: sitio.descripcion,
            ),
          );
        }).toSet(),
      ),
    );
  }
}
