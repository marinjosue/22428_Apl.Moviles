import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config/api_config.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_view.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
    _cargarPromedio();
  }

  Future<void> _cargarComentarios() async {
    final url = Uri.parse('${ApiConfig.apiBase}/comentarios/sitio/${widget.sitio['_id']}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      setState(() => _comentarios = jsonDecode(res.body));
    }
  }

  Future<void> _cargarPromedio() async {
    final url = Uri.parse('${ApiConfig.apiBase}/comentarios/sitio/${widget.sitio['_id']}/promedio');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        _promedio = double.parse(data['promedio']);
        _total = data['total'];
        _cargando = false;
      });
    }
  }

  Future<void> _enviarComentario(String uid, String nombre) async {
    final url = Uri.parse('${ApiConfig.apiBase}/comentarios');
    final body = jsonEncode({
      'sitioId': widget.sitio['_id'],
      'usuarioId': uid,
      'nombreUsuario': nombre,
      'texto': _nuevoComentario,
      'calificacion': _nuevaCalificacion,
    });

    final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);
    if (res.statusCode == 201) {
      _nuevoComentario = '';
      await _cargarComentarios();
      await _cargarPromedio();
    }
  }

  Future<void> _agregarFavorito(String uid) async {
    final url = Uri.parse('${ApiConfig.apiBase}/user/$uid/favoritos');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sitioId': widget.sitio['_id']}),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregado a favoritos')));
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
            SizedBox(
              height: 200,
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
            const SizedBox(height: 12),
            Text(sitio['descripcion'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            if (!_cargando)
              Text('⭐ $_promedio / 5.0   ($_total valoraciones)', style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            if (authVM.isAuthenticated)
              ElevatedButton.icon(
                onPressed: () => _agregarFavorito(authVM.usuario!['uid']),
                icon: const Icon(Icons.favorite_border),
                label: const Text('Agregar a favoritos'),
              ),
            const SizedBox(height: 16),
            const Text('Comentarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var c in _comentarios)
              ListTile(
                title: Text(c['nombreUsuario']),
                subtitle: Text(c['texto']),
                trailing: Text('${c['calificacion']} ⭐'),
              ),
            const SizedBox(height: 16),
            if (authVM.isAuthenticated)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tu comentario:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ElevatedButton(
                    onPressed: _nuevoComentario.trim().isEmpty
                        ? null
                        : () => _enviarComentario(authVM.usuario!['uid'], authVM.usuario!['name']),
                    child: const Text('Publicar comentario'),
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
    );
  }
}
