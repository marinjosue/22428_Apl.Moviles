import '../config/api_config.dart';
import '../models/comentario.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ComentarioService {
  static String apiBase = ApiConfig.apiBase;

  // Mock data para testing local
  static List<Comentario> _comentariosMock = [];
  static int _nextId = 1;

  // Obtener comentarios de un sitio turístico
  Future<List<Comentario>> getComentariosBySitio(String sitioId) async {
    try {
      final url = Uri.parse('$apiBase/comentarios/sitio/$sitioId');
      final res = await http.get(url);
      
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => Comentario.fromMap(json, json['_id'] ?? json['id'])).toList();
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Usando datos mock locales...');
    }
    
    // Fallback a datos mock
    return _comentariosMock.where((c) => c.sitioId == sitioId).toList();
  }

  // Crear nuevo comentario
  Future<void> crearComentario({
    required String sitioId,
    required String usuarioId,
    required String nombreUsuario,
    required String texto,
    required double calificacion,
  }) async {
    try {
      final url = Uri.parse('$apiBase/comentarios');
      final res = await http.post(
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
      
      if (res.statusCode != 201) {
        throw Exception('Error al crear comentario');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Guardando comentario localmente...');
      
      // Fallback a datos mock
      final comentario = Comentario(
        id: (_nextId++).toString(),
        sitioId: sitioId,
        usuarioId: usuarioId,
        nombreUsuario: nombreUsuario,
        texto: texto,
        calificacion: calificacion,
        fecha: DateTime.now(),
      );
      _comentariosMock.add(comentario);
    }
  }

  // Actualizar comentario
  Future<void> actualizarComentario({
    required String comentarioId,
    required String texto,
    required double calificacion,
  }) async {
    try {
      final url = Uri.parse('$apiBase/comentarios/$comentarioId');
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'texto': texto,
          'calificacion': calificacion,
        }),
      );
      
      if (res.statusCode != 200) {
        throw Exception('Error al actualizar comentario');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Actualizando comentario localmente...');
      
      // Fallback a datos mock
      final index = _comentariosMock.indexWhere((c) => c.id == comentarioId);
      if (index != -1) {
        final comentarioOriginal = _comentariosMock[index];
        _comentariosMock[index] = Comentario(
          id: comentarioOriginal.id,
          sitioId: comentarioOriginal.sitioId,
          usuarioId: comentarioOriginal.usuarioId,
          nombreUsuario: comentarioOriginal.nombreUsuario,
          texto: texto,
          calificacion: calificacion,
          fecha: comentarioOriginal.fecha,
        );
      }
    }
  }

  // Eliminar comentario
  Future<void> eliminarComentario(String comentarioId) async {
    try {
      final url = Uri.parse('$apiBase/comentarios/$comentarioId');
      final res = await http.delete(url);
      
      if (res.statusCode != 200) {
        throw Exception('Error al eliminar comentario');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Eliminando comentario localmente...');
      
      // Fallback a datos mock
      _comentariosMock.removeWhere((c) => c.id == comentarioId);
    }
  }

  // Obtener comentarios de un usuario
  Future<List<Comentario>> getComentariosByUsuario(String usuarioId) async {
    try {
      final url = Uri.parse('$apiBase/comentarios/usuario/$usuarioId');
      final res = await http.get(url);
      
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => Comentario.fromMap(json, json['_id'] ?? json['id'])).toList();
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
    }
    
    // Fallback a datos mock
    return _comentariosMock.where((c) => c.usuarioId == usuarioId).toList();
  }

  // Obtener calificación promedio de un sitio
  Future<double> getCalificacionPromedio(String sitioId) async {
    try {
      final url = Uri.parse('$apiBase/comentarios/sitio/$sitioId/promedio');
      final res = await http.get(url);
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['promedio'] ?? 0.0).toDouble();
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
    }
    
    // Fallback a cálculo local
    final comentariosSitio = _comentariosMock.where((c) => c.sitioId == sitioId).toList();
    if (comentariosSitio.isEmpty) return 0.0;
    
    final suma = comentariosSitio.fold(0.0, (sum, c) => sum + c.calificacion);
    return suma / comentariosSitio.length;
  }
}
