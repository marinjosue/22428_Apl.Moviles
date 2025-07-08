import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TransporteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opciones de Transporte: Sangolquí - Quito',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Transporte público
            _buildTransportSection(
              context,
              title: 'Transporte Público',
              iconData: Icons.directions_bus,
              color: Colors.blue,
              options: [
                TransportOption(
                  title: 'Buses Urbanos - Ruta Sangolquí-Quito',
                  description: 'Diferentes rutas que conectan Sangolquí con Quito',
                  icon: Icons.directions_bus,
                  busStops: [
                    BusStop(
                      name: 'Terminal Terrestre Sangolquí',
                      latitude: -0.3302492,
                      longitude: -78.4464923,
                      address: 'Av. Gral. Enríquez, Sangolquí'
                    ),
                    BusStop(
                      name: 'Parada El Tingo',
                      latitude: -0.2902799,
                      longitude: -78.4264695,
                      address: 'Vía Intervalles, El Tingo'
                    ),
                    BusStop(
                      name: 'Estación La Magdalena',
                      latitude: -0.2547865,
                      longitude: -78.5255963,
                      address: 'Av. Simón Bolívar, Quito'
                    ),
                  ],
                  tarifa: '\$0.30 - \$0.50',
                  horario: '5:30 AM - 10:30 PM'
                ),
                TransportOption(
                  title: 'Metro de Quito',
                  description: 'Sistema integrado de transporte público',
                  icon: Icons.tram,
                  busStops: [
                    BusStop(
                      name: 'Estación Quitumbe',
                      latitude: -0.3157728,
                      longitude: -78.5509392,
                      address: 'Av. Cóndor Ñan, Quito'
                    ),
                    BusStop(
                      name: 'Estación El Labrador',
                      latitude: -0.2547865,
                      longitude: -78.5255963,
                      address: 'Av. Simón Bolívar, Quito'
                    ),
                    BusStop(
                      name: 'Estación Universidad Central',
                      latitude: -0.2105263,
                      longitude: -78.5047493,
                      address: 'Av. América, Quito'
                    ),
                  ],
                  tarifa: '\$0.35',
                  horario: '5:30 AM - 10:30 PM'
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Taxis
            _buildTransportSection(
              context,
              title: 'Taxis y Transporte Privado',
              iconData: Icons.local_taxi,
              color: Colors.yellow.shade800,
              options: [
                TransportOption(
                  title: 'Taxis Amarillos',
                  description: 'Servicio de taxi tradicional',
                  icon: Icons.local_taxi,
                  busStops: [
                    BusStop(
                      name: 'Parada Taxis Sangolquí',
                      latitude: -0.3309621,
                      longitude: -78.4464286,
                      address: 'Parque Central Sangolquí'
                    ),
                    BusStop(
                      name: 'Terminal Terrestre Quitumbe',
                      latitude: -0.3157728,
                      longitude: -78.5509392,
                      address: 'Av. Cóndor Ñan, Quito'
                    ),
                  ],
                  tarifa: '\$1.50 inicial + \$0.10 por cada 100m',
                  horario: '24/7'
                ),
                TransportOption(
                  title: 'Uber/Cabify',
                  description: 'Aplicaciones de transporte por demanda',
                  icon: Icons.app_shortcut,
                  busStops: [
                    BusStop(
                      name: 'Zona de Recogida Centro Comercial San Luis',
                      latitude: -0.3322492,
                      longitude: -78.4474923,
                      address: 'San Luis Shopping, Sangolquí'
                    ),
                    BusStop(
                      name: 'Aeropuerto Mariscal Sucre',
                      latitude: -0.1292100,
                      longitude: -78.3575900,
                      address: 'Vía Yaruquí, Quito'
                    ),
                  ],
                  tarifa: 'Variable según distancia',
                  horario: '24/7'
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Alquiler de vehículos
            _buildTransportSection(
              context,
              title: 'Alquiler de Vehículos',
              iconData: Icons.car_rental,
              color: Colors.green,
              options: [
                TransportOption(
                  title: 'Rent a Car',
                  description: 'Alquiler de automóviles por día',
                  icon: Icons.car_rental,
                  busStops: [
                    BusStop(
                      name: 'Localiza Rent a Car',
                      latitude: -0.1292100,
                      longitude: -78.3575900,
                      address: 'Aeropuerto Mariscal Sucre, Quito'
                    ),
                    BusStop(
                      name: 'Budget Rent a Car',
                      latitude: -0.2067861,
                      longitude: -78.4903273,
                      address: 'Av. Amazonas, Quito'
                    ),
                  ],
                  tarifa: '\$30 - \$80 por día',
                  horario: '7:00 AM - 8:00 PM'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportSection(
    BuildContext context, {
    required String title,
    required IconData iconData,
    required Color color,
    required List<TransportOption> options,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, color: color, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...options.map((option) => _buildOptionCard(context, option)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, TransportOption option) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(option.icon, color: Colors.teal),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(option.description),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('${option.horario}', style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
                Icon(Icons.attach_money, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('${option.tarifa}', style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Paradas/Ubicaciones:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...option.busStops.map((stop) => _buildStopTile(context, stop)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStopTile(BuildContext context, BusStop stop) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.location_on, color: Colors.red),
        title: Text(stop.name),
        subtitle: Text(stop.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.map, color: Colors.blue),
              onPressed: () => _launchGoogleMaps(context, stop),
            ),
            IconButton(
              icon: Icon(Icons.directions, color: Colors.green),
              onPressed: () => _launchGoogleMapsDirections(context, stop),
            ),
          ],
        ),
      ),
    );
  }

  void _launchGoogleMaps(BuildContext context, BusStop stop) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${stop.latitude},${stop.longitude}';
    Uri uri = Uri.parse(googleUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el mapa: $e')),
      );
    }
  }

  void _launchGoogleMapsDirections(BuildContext context, BusStop stop) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=${stop.latitude},${stop.longitude}&travelmode=driving';
    Uri uri = Uri.parse(googleUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener indicaciones: $e')),
      );
    }
  }
}

class TransportOption {
  final String title;
  final String description;
  final IconData icon;
  final List<BusStop> busStops;
  final String tarifa;
  final String horario;

  TransportOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.busStops,
    required this.tarifa,
    required this.horario,
  });
}

class BusStop {
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  BusStop({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
