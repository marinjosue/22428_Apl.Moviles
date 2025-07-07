import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/usuario.dart';

class UserService {
  final String _baseUrl = ApiConfig.apiBase;

  Future<void> crearOActualizarUsuario(String uid, String name, String email, String photoUrl) async {
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear/actualizar usuario: ${response.body}');
    }
  }

  Future<Usuario> registrarUsuario(String email, String password, String nombre) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'email': email,
        'password': password,
        'nombre': nombre,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromMap(data, data['id'] ?? '');
    } else {
      throw Exception('Error al registrar usuario: \\n${response.body}');
    }
  }

  Future<Usuario> loginUsuario(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromMap(data, data['id'] ?? '');
    } else {
      throw Exception('Error al iniciar sesión: \\n${response.body}');
    }
  }

  Future<Usuario> getPerfilUsuario(String id) async {
    final url = Uri.parse('$_baseUrl/user/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromMap(data, data['id'] ?? id);
    } else {
      throw Exception('Error al obtener perfil: ${response.body}');
    }
  }

  Future<void> actualizarPerfilUsuario(String id, String nombre, String email) async {
    final url = Uri.parse('$_baseUrl/user/$id');
    final response = await http.put(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar perfil: ${response.body}');
    }
  }
}
