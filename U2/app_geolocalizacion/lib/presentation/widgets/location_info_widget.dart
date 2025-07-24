import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Consumer<LocationProvider>(
        builder: (context, provider, child) {
          final location = provider.location;

          if (location == null) return const SizedBox(height: 20);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Ubicación Actual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Lat: ${location.latitude.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Lng: ${location.longitude.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 14),
              ),
              if (location.address != null) ...[
                const SizedBox(height: 4),
                Text(
                  location.address!,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
                