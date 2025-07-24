import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/api_config.dart';
import '../models/usuario.dart';

class UsuarioRepository {
  final String _baseUrl = ApiConfig.apiBase;

  // Get user profile by ID
  Future<Usuario> getUsuario(String uid) async {
    final url = Uri.parse('$_baseUrl/user/$uid');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromMap(data, data['_id'] ?? uid);
    } else {
      throw Exception('Error al obtener perfil: ${response.statusCode}');
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(String uid, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'user': data['user']};
    } else {
      return {
        'success': false, 
        'message': jsonDecode(response.body)['error'] ?? 'Error de autenticación'
      };
    }
  }

  // Register new user
  Future<Map<String, dynamic>> register(
    String uid, 
    String name, 
    String email, 
    String password, 
    [String photoUrl = '']
  ) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'photoUrl': photoUrl
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      return {
        'success': false, 
        'message': jsonDecode(response.body)['error'] ?? 'Error en el registro'
      };
    }
  }

  // Add site to favorites
  Future<bool> addToFavorites(String uid, String sitioId) async {
    final url = Uri.parse('$_baseUrl/user/$uid/favoritos');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sitioId': sitioId}),
    );
    
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Remove site from favorites
  Future<bool> removeFromFavorites(String uid, String sitioId) async {
    final url = Uri.parse('$_baseUrl/user/$uid/favoritos');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sitioId': sitioId}),
    );
    
    return response.statusCode == 200;
  }

  // Check if site is in favorites
  Future<bool> checkFavorite(String uid, String sitioId) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$uid/favoritos/check/$sitioId');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get all favorites
  Future<List<String>> getUserFavorites(String uid) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$uid/favoritos');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Update user profile
  Future<bool> updateProfile(String uid, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/user/$uid');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    
    return response.statusCode == 200;
  }
}
