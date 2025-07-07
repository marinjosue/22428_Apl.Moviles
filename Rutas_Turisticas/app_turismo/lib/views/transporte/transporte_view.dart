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
              'Opciones de Transporte',
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
                  title: 'Buses Urbanos',
                  description: 'Diferentes rutas que conectan los principales puntos turísticos',
                  icon: Icons.directions_bus,
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Buses Urbanos',
                    'Servicio desde 6:00 AM hasta 10:00 PM. Tarifa: \$0.30',
                    'https://maps.app.goo.gl/nF5WKHsHibfRGWiP6',
                  )
                ),
                TransportOption(
                  title: 'Metro/Trolebús',
                  description: 'Sistema integrado de transporte público',
                  icon: Icons.tram,
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Sistema Integrado Metro/Trolebús',
                    'Servicio desde 5:30 AM hasta 10:30 PM. Tarifa: \$0.35',
                    'https://maps.app.goo.gl/Sf2yQgLtPtroLKH16',
                  )
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Taxis
            _buildTransportSection(
              context,
              title: 'Taxis',
              iconData: Icons.local_taxi,
              color: Colors.yellow.shade800,
              options: [
                TransportOption(
                  title: 'Taxis Amarillos',
                  description: 'Servicio de taxi tradicional',
                  icon: Icons.local_taxi,
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Taxis Amarillos',
                    'Disponible 24/7. Tarifa inicial: \$1.50',
                    null,
                  )
                ),
                TransportOption(
                  title: 'Uber/Cabify',
                  description: 'Aplicaciones de transporte por demanda',
                  icon: Icons.app_shortcut,
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Aplicaciones de Transporte',
                    'Descargue Uber o Cabify desde su tienda de aplicaciones',
                    'https://play.google.com/store/apps/details?id=com.ubercab',
                  )
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
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Alquiler de Automóviles',
                    'Precios desde \$30 por día. Requiere licencia de conducir válida',
                    'https://maps.app.goo.gl/MaFErGqcmM54hHLy5',
                  )
                ),
                TransportOption(
                  title: 'Alquiler de Bicicletas',
                  description: 'Opción ecológica para recorrer la ciudad',
                  icon: Icons.pedal_bike,
                  onTap: () => _mostrarDetalleTransporte(
                    context, 
                    'Alquiler de Bicicletas',
                    'Servicio desde \$5 por hora. Incluye casco y candado',
                    'https://maps.app.goo.gl/23tYnXXtmgbvLM6t7',
                  )
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
            ...options.map((option) => _buildOptionTile(option)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(TransportOption option) {
    return ListTile(
      leading: Icon(option.icon, color: Colors.teal),
      title: Text(option.title),
      subtitle: Text(option.description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: option.onTap,
    );
  }

  void _mostrarDetalleTransporte(
    BuildContext context, 
    String title, 
    String details, 
    String? mapUrl
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details),
            if (mapUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.map),
                  label: Text('Ver en mapa'),
                  onPressed: () async {
                    final Uri uri = Uri.parse(mapUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No se pudo abrir el mapa')),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class TransportOption {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  TransportOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
}
