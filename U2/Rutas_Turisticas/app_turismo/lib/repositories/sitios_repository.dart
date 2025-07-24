import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/sitio_turistico.dart';
import '../models/comentario.dart';

class SitiosRepository {
  final String _baseUrl = ApiConfig.apiBase;

  // Get all tourist sites
  Future<List<SitioTuristico>> getSitios() async {
    try {
      final url = Uri.parse('$_baseUrl/sitios');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => 
          SitioTuristico.fromMap(item, item['_id'] ?? item['id'] ?? '')
        ).toList();
      } else {
        throw Exception('Error al obtener sitios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Get site by ID
  Future<SitioTuristico> getSitioById(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/sitios/$id');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SitioTuristico.fromMap(data, data['_id'] ?? id);
      } else {
        throw Exception('Sitio no encontrado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Get comments for a site
  Future<List<Comentario>> getComentariosBySitio(String sitioId) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/sitio/$sitioId');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => 
          Comentario.fromMap(item, item['_id'] ?? item['id'] ?? '')
        ).toList();
      } else {
        throw Exception('Error al obtener comentarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Get average rating for a site
  Future<Map<String, dynamic>> getPromedioCalificacion(String sitioId) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/sitio/$sitioId/promedio');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'promedio': 0.0, 'total': 0};
      }
    } catch (e) {
      return {'promedio': 0.0, 'total': 0};
    }
  }

  // Add comment to a site
  Future<bool> addComentario(Map<String, dynamic> comentario) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(comentario),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al agregar comentario: $e');
    }
  }

  // Search sites by criteria (name, category, etc)
  Future<List<SitioTuristico>> searchSitios(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/sitios/search?q=$query');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => 
          SitioTuristico.fromMap(item, item['_id'] ?? item['id'] ?? '')
        ).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
