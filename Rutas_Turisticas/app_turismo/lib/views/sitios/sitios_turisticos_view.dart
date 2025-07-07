import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_config.dart';
import 'sitio_detalle_view.dart';

class SitiosTuristicosView extends StatefulWidget {
  @override
  State<SitiosTuristicosView> createState() => _SitiosTuristicosViewState();
}

class _SitiosTuristicosViewState extends State<SitiosTuristicosView> {
  List<dynamic> sitios = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/sitios');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          sitios = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error al cargar datos: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!, style: TextStyle(color: Colors.red)));
    }

    if (sitios.isEmpty) {
      return Center(child: Text('No hay sitios turísticos disponibles'));
    }

    return RefreshIndicator(
      onRefresh: cargarSitios,
      child: ListView.builder(
        itemCount: sitios.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final sitio = sitios[index];
          
          // Obtener la imagen o usar una predeterminada
          String imageUrl = sitio['imagenes'] != null && 
                          sitio['imagenes'].isNotEmpty ? 
                          sitio['imagenes'][0] : 
                          'https://via.placeholder.com/150?text=Sin+Imagen';
          
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
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
