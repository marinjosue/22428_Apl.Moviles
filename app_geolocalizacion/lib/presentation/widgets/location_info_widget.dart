import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context).location;

    if (location == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Text(
        'Lat: ${location.latitude.toStringAsFixed(5)}, '
        'Lng: ${location.longitude.toStringAsFixed(5)}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
