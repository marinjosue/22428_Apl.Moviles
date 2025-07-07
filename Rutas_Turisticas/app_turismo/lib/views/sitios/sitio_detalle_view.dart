import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Add this for TimeoutException
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../../config/api_config.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_view.dart';
import '../comentarios/comentarios_view.dart';

class SitioDetalleView extends StatefulWidget {
  final Map<String, dynamic> sitio;
  const SitioDetalleView({super.key, required this.sitio});

  @override
  State<SitioDetalleView> createState() => _SitioDetalleViewState();
}

class _SitioDetalleViewState extends State<SitioDetalleView> {
  late GoogleMapController _mapController;
  List<dynamic> _comentarios = [];
  String _nuevoComentario = '';
  double _nuevaCalificacion = 5.0;
  bool _cargando = true;
  double _promedio = 0.0;
  int _total = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
    _cargarPromedio();
    _verificarFavorito();
  }

  Future<void> _cargarComentarios() async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/comentarios/sitio/${widget.sitio['_id']}');
      final res = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado tiempo');
        },
      );
      
      if (res.statusCode == 200) {
        setState(() => _comentarios = jsonDecode(res.body));
      }
    } catch (e) {
      print('Error al cargar comentarios: $e');
      // No establecemos comentarios como vacío para evitar sobrescribir datos anteriores en caso de error
    }
  }

  Future<void> _cargarPromedio() async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/comentarios/sitio/${widget.sitio['_id']}/promedio');
      final res = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado tiempo');
        },
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _promedio = double.parse(data['promedio'].toString());
          _total = data['total'];
          _cargando = false;
        });
      }
    } catch (e) {
      print('Error al cargar promedio: $e');
      setState(() => _cargando = false);
    }
  }

  Future<void> _verificarFavorito() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    if (!authVM.isAuthenticated) return;
    
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/user/${authVM.usuario!['uid']}/favoritos/check/${widget.sitio['_id']}');
      final res = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado tiempo');
        },
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _isFavorite = data['isFavorite']);
      }
    } catch (e) {
      print('Error al verificar favorito: $e');
      // Mantener _isFavorite con su valor predeterminado
    }
  }

  Future<void> _enviarComentario(String uid, String nombre) async {
    try {
      setState(() => _cargando = true);
      
      final url = Uri.parse('${ApiConfig.apiBase}/comentarios');
      final body = jsonEncode({
        'sitioId': widget.sitio['_id'],
        'usuarioId': uid,
        'nombreUsuario': nombre,
        'texto': _nuevoComentario,
        'calificacion': _nuevaCalificacion,
        'fecha': DateTime.now().toIso8601String(),
      });

      final res = await http.post(
        url, 
        headers: {'Content-Type': 'application/json'}, 
        body: body
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado tiempo');
        },
      );
      
      if (res.statusCode == 201) {
        setState(() {
          _nuevoComentario = '';
          // Agregar el nuevo comentario localmente para evitar tener que recargar
          _comentarios.insert(0, {
            '_id': DateTime.now().toString(), // ID temporal
            'usuarioId': uid,
            'nombreUsuario': nombre,
            'texto': _nuevoComentario,
            'calificacion': _nuevaCalificacion,
            'fecha': DateTime.now().toIso8601String(),
          });
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario publicado con éxito'))
        );
        
        await _cargarComentarios();
        await _cargarPromedio();
      } else {
        _mostrarErrorSnackbar('Error al publicar comentario');
      }
    } catch (e) {
      print('Error al enviar comentario: $e');
      _mostrarErrorSnackbar('No se pudo enviar el comentario: Comprueba tu conexión');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _toggleFavorito(String uid) async {
    try {
      final url = Uri.parse('${ApiConfig.apiBase}/user/$uid/favoritos');
      
      // Optimistic update - actualizar UI inmediatamente
      setState(() => _isFavorite = !_isFavorite);
      
      if (!_isFavorite) {
        // Eliminar de favoritos (era favorito antes del toggle)
        await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'sitioId': widget.sitio['_id']}),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('La conexión tardó demasiado tiempo');
          },
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado de favoritos'))
        );
      } else {
        // Agregar a favoritos (no era favorito antes del toggle)
        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'sitioId': widget.sitio['_id']}),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('La conexión tardó demasiado tiempo');
          },
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agregado a favoritos'))
        );
      }
    } catch (e) {
      print('Error en operación de favoritos: $e');
      // Revertir el cambio optimista en caso de error
      setState(() => _isFavorite = !_isFavorite);
      _mostrarErrorSnackbar('Error al actualizar favoritos: Comprueba tu conexión');
    }
  }
  
  void _mostrarErrorSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      )
    );
  }

  // Método para abrir la ubicación en Google Maps o Apple Maps
  Future<void> _abrirRutaEnMapa() async {
    final sitio = widget.sitio;
    final lat = sitio['latitud'];
    final lng = sitio['longitud'];
    final nombre = Uri.encodeComponent(sitio['nombre'] ?? '');

    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng($nombre)';
    String appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';

    String url = Platform.isIOS ? appleMapsUrl : googleMapsUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _mostrarErrorSnackbar('No se pudo abrir la aplicación de mapas.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final sitio = widget.sitio;

    return Scaffold(
      appBar: AppBar(title: Text(sitio['nombre'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mapa
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(sitio['latitud'], sitio['longitud']),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('sitio'),
                    position: LatLng(sitio['latitud'], sitio['longitud']),
                    infoWindow: InfoWindow(title: sitio['nombre']),
                  ),
                },
                onMapCreated: (controller) => _mapController = controller,
              ),
            ),
            
            // Botón para abrir ruta
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                onPressed: _abrirRutaEnMapa,
                icon: Icon(Icons.directions, size: 24),
                label: Text('Cómo llegar', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blue.withOpacity(0.5),
                ),
              ),
            ),

            // Descripción
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(sitio['descripcion'], style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Valoración promedio
            if (!_cargando)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '$_promedio / 5.0',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text('($_total valoraciones)'),
                    ],
                  ),
                ),
              ),
              
            const SizedBox(height: 16),
            
            // Botón de favoritos
            if (authVM.isAuthenticated)
              ElevatedButton.icon(
                onPressed: () => _toggleFavorito(authVM.usuario!['uid']),
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                  size: 22,
                ),
                label: Text(
                  _isFavorite ? 'Eliminar de favoritos' : 'Agregar a favoritos',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: _isFavorite ? Colors.grey.shade200 : Colors.pink.shade50,
                ),
              ),
              
            const SizedBox(height: 16),
            
            // Sección de comentarios
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comentarios recientes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComentariosView(
                                  sitioId: widget.sitio['_id'],
                                  sitioNombre: widget.sitio['nombre'],
                                ),
                              ),
                            );
                          },
                          child: Text('Ver todos'),
                        ),
                      ],
                    ),
                    
                    // Lista de comentarios (máximo 3)
                    if (_comentarios.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('No hay comentarios aún. ¡Sé el primero en comentar!'),
                      )
                    else
                      for (var i = 0; i < (_comentarios.length > 3 ? 3 : _comentarios.length); i++)
                        ListTile(
                          title: Text(_comentarios[i]['nombreUsuario']),
                          subtitle: Text(_comentarios[i]['texto']),
                          trailing: Text('${_comentarios[i]['calificacion']} ⭐'),
                        ),
                    
                    const Divider(),
                    
                    // Formulario de comentario
                    if (authVM.isAuthenticated)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Deja tu comentario:', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            onChanged: (val) => _nuevoComentario = val,
                            decoration: const InputDecoration(hintText: 'Escribe tu opinión'),
                          ),
                          Row(
                            children: [
                              const Text('Calificación:'),
                              Slider(
                                value: _nuevaCalificacion,
                                onChanged: (val) => setState(() => _nuevaCalificacion = val),
                                divisions: 4,
                                min: 1,
                                max: 5,
                                label: _nuevaCalificacion.toStringAsFixed(1),
                              ),
                              Text('${_nuevaCalificacion.toStringAsFixed(1)} ⭐'),
                            ],
                          ),
                          // Update the comment publication button
                          ElevatedButton(
                            onPressed: _nuevoComentario.trim().isEmpty
                                ? null
                                : () => _enviarComentario(authVM.usuario!['uid'], authVM.usuario!['name']),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text('Publicar comentario'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginView()),
                          );
                        },
                        child: const Text('Inicia sesión para comentar'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

