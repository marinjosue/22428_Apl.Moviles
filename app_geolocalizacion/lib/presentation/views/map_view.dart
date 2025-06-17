import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../widgets/location_info_widget.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);
    final loc = provider.location;

    return Scaffold(
      appBar: AppBar(title: const Text('Geolocalización')),
      body: Stack(
        children: [
          if (loc != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(loc.latitude, loc.longitude),
                zoom: 16,
              ),
              myLocationEnabled: true,
            )
          else
            const Center(child: CircularProgressIndicator()),
          const Align(
            alignment: Alignment.bottomCenter,
            child: LocationInfoWidget(),
          ),
        ],
      ),
    );
  }
}
