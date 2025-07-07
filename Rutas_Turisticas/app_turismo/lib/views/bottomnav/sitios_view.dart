import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_config.dart';
import '../sitios/sitio_detalle_view.dart';

class SitiosView extends StatefulWidget {
  const SitiosView({super.key});

  @override
  State<SitiosView> createState() => _SitiosViewState();
}

class _SitiosViewState extends State<SitiosView> {
  List<dynamic> sitios = [];
  bool isLoading = true;
  String? error;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  // Safe setState that checks if widget is still mounted
  void _safeSetState(VoidCallback fn) {
    if (_mounted && mounted) {
      setState(fn);
    }
  }

  Future<void> cargarSitios() async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/sitios');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _safeSetState(() {
          sitios = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        _safeSetState(() {
          error = 'Error al cargar datos: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      _safeSetState(() {
        error = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 70, color: Colors.red.shade300),
            SizedBox(height: 16),
            Text(
              'No se pudieron cargar los sitios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, size: 20),
              label: Text('Reintentar', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: () {
                _safeSetState(() {
                  isLoading = true;
                  error = null;
                });
                cargarSitios();
              },
            )
          ],
        ),
      );
    }

    if (sitios.isEmpty) {
      return const Center(child: Text('No hay sitios disponibles.'));
    }

    return RefreshIndicator(
      onRefresh: cargarSitios,
      child: ListView.builder(
        itemCount: sitios.length,
        itemBuilder: (context, index) {
          final sitio = sitios[index];
          
          // Obtener la imagen o usar una predeterminada
          String imageUrl = sitio['imagenes'] != null && 
                          sitio['imagenes'].isNotEmpty ? 
                          sitio['imagenes'][0] : 
                          'https://via.placeholder.com/150?text=Sin+Imagen';
          
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SitioDetalleView(sitio: sitio),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del sitio
                  Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.image, size: 50)),
                      );
                    },
                  ),
                  
                  // Información del sitio
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sitio['nombre'] ?? 'Sin nombre',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          sitio['descripcion'] ?? 'Sin descripción',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Ver ubicación',
                              style: TextStyle(color: Colors.blue),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
