import '../config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sitio_turistico.dart';

class SitiosService {
  final String apiBase = ApiConfig.apiBase;

  Future<void> inicializarDatos() async {
    // Si necesitas inicializar algo, ponlo aquí. Si no, puedes dejarlo vacío.
    return;
  }

  Future<List<SitioTuristico>> getSitios() async {
    final url = Uri.parse('$apiBase/sitios');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => SitioTuristico.fromMap(e, e['_id'] ?? e['id'] ?? '')).toList();
    } else {
      throw Exception('Error al obtener sitios: ${res.statusCode}');
    }
  }

  Future<void> crearSitio({
    required String nombre,
    required String descripcion,
    required double latitud,
    required double longitud,
    String categoria = 'general',
    List<String> imagenes = const [],
  }) async {
    final url = Uri.parse('$apiBase/sitios');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'descripcion': descripcion,
        'latitud': latitud,
        'longitud': longitud,
        'categoria': categoria,
        'imagenes': imagenes,
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear sitio: ${res.statusCode}');
    }
  }
}
