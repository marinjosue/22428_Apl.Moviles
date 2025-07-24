import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../../config/api_config.dart';
import '../sitios/sitio_detalle_view.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  final LatLng _defaultLocation = LatLng(-0.225219, -78.5248);
  
  @override
  void initState() {
    super.initState();
    _cargarSitios();
  }

  Future<void> _cargarSitios() async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/sitios');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> sitios = jsonDecode(response.body);
        _crearMarcadores(sitios);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar sitios: ${response.statusCode}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e'))
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _crearMarcadores(List<dynamic> sitios) {
    Set<Marker> marcadores = {};
    
    for (final sitio in sitios) {
      if (sitio['latitud'] == null || sitio['longitud'] == null) continue;
      
      final marker = Marker(
        markerId: MarkerId(sitio['_id']),
        position: LatLng(sitio['latitud'], sitio['longitud']),
        infoWindow: InfoWindow(
          title: sitio['nombre'],
          snippet: 'Toca para más información',
        ),
        onTap: () => _mostrarOpcionesSitio(sitio),
      );
      
      marcadores.add(marker);
    }
    
    if (mounted) {
      setState(() => _markers = marcadores);
    }
  }

  void _mostrarOpcionesSitio(Map<String, dynamic> sitio) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Ver detalles'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SitioDetalleView(sitio: sitio),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions),
                title: Text('Cómo llegar'),
                onTap: () {
                  Navigator.pop(context);
                  _abrirRutaEnMapa(
                    sitio['latitud'],
                    sitio['longitud'],
                    sitio['nombre'],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _abrirRutaEnMapa(double lat, double lng, String nombre) async {
    final encodedNombre = Uri.encodeComponent(nombre);
    
    Uri mapUrl;
    
    if (Platform.isAndroid) {
      mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$encodedNombre'
      );
    } else if (Platform.isIOS) {
      mapUrl = Uri.parse(
        'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d'
      );
    } else {
      mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'
      );
    }
    
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el mapa'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 11,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() => _isLoading = true);
          _cargarSitios();
        },
      ),
    );
  }
}
