import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/comentario.dart';

class ComentariosRepository {
  final String _baseUrl = ApiConfig.apiBase;

  // Get comments by site ID
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

  // Get comments by user ID
  Future<List<Comentario>> getComentariosByUsuario(String usuarioId) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/usuario/$usuarioId');
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

  // Create new comment
  Future<Comentario> createComentario({
    required String sitioId,
    required String usuarioId,
    required String nombreUsuario,
    required String texto,
    required double calificacion,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sitioId': sitioId,
          'usuarioId': usuarioId,
          'nombreUsuario': nombreUsuario,
          'texto': texto,
          'calificacion': calificacion,
          'fecha': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Comentario.fromMap(data, data['_id'] ?? data['id'] ?? '');
      } else {
        throw Exception('Error al crear comentario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Update existing comment
  Future<bool> updateComentario({
    required String comentarioId,
    required String texto,
    required double calificacion,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/$comentarioId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'texto': texto,
          'calificacion': calificacion,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Delete comment
  Future<bool> deleteComentario(String comentarioId) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/$comentarioId');
      final response = await http.delete(url);
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Get average rating for site
  Future<double> getCalificacionPromedio(String sitioId) async {
    try {
      final url = Uri.parse('$_baseUrl/comentarios/sitio/$sitioId/promedio');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['promedio'] ?? 0.0).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }
}
