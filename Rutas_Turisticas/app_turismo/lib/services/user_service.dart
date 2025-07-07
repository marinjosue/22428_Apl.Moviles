import '../config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  // Solo usas la config:
  static  String apiBase = ApiConfig.apiBase;

  // Mock data para testing local
  static Map<String, Map<String, dynamic>> _usuariosMock = {};

  Future<void> crearOActualizarPerfil({
    required String uid,
    required String name,
    required String email,
    String photoUrl = '',
  }) async {
    try {
      final url = Uri.parse('$apiBase/user');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'name': name,
          'email': email,
          'photoUrl': photoUrl,
        }),
      );
        print('Respuesta registro usuario: ${res.statusCode} - ${res.body}'); // <-- AGREGA ESTO

      if (res.statusCode != 200) {
        throw Exception('Error al crear/actualizar perfil');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Guardando perfil localmente...');
      
      // Fallback a datos mock
      _usuariosMock[uid] = {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'favoritos': _usuariosMock[uid]?['favoritos'] ?? [],
        'fechaRegistro': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>?> getPerfil(String uid) async {
    try {
      final url = Uri.parse('$apiBase/user/$uid');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
    }
    
    // Fallback a datos mock
    return _usuariosMock[uid];
  }

  Future<void> agregarFavorito(String uid, String sitioId) async {
    try {
      final url = Uri.parse('$apiBase/user/$uid/favoritos');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sitioId': sitioId}),
      );
      if (res.statusCode != 200) {
        throw Exception('Error al agregar favorito');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Agregando favorito localmente...');
      
      // Fallback a datos mock
      if (_usuariosMock[uid] != null) {
        final favoritos = List<String>.from(_usuariosMock[uid]!['favoritos'] ?? []);
        if (!favoritos.contains(sitioId)) {
          favoritos.add(sitioId);
          _usuariosMock[uid]!['favoritos'] = favoritos;
        }
      }
    }
  }

  Future<void> eliminarFavorito(String uid, String sitioId) async {
    try {
      final url = Uri.parse('$apiBase/user/$uid/favoritos');
      final res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sitioId': sitioId}),
      );
      if (res.statusCode != 200) {
        throw Exception('Error al eliminar favorito');
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
      print('Eliminando favorito localmente...');
      
      // Fallback a datos mock
      if (_usuariosMock[uid] != null) {
        final favoritos = List<String>.from(_usuariosMock[uid]!['favoritos'] ?? []);
        favoritos.remove(sitioId);
        _usuariosMock[uid]!['favoritos'] = favoritos;
      }
    }
  }

  Future<List<String>> getFavoritos(String uid) async {
    try {
      final url = Uri.parse('$apiBase/user/$uid/favoritos');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<String>.from(data['favoritos'] ?? []);
      }
    } catch (e) {
      print('Error conectando al servidor: $e');
    }
    
    // Fallback a datos mock
    return List<String>.from(_usuariosMock[uid]?['favoritos'] ?? []);
  }
}
