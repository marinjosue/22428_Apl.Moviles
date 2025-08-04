import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import '../models/user.dart';
import '../models/login_response.dart';

class BackendService {
  // Autenticación
  Future<LoginResponse> login(String email, String password) async {
    try {
      print('Intentando login con: $email');
      final response = await http.post(
        Uri.parse('$kBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      print('Error en login: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      print('Intentando registro con: $name, $email');
      final response = await http.post(
        Uri.parse('$kBaseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      print('Error en registro: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener información del usuario usando el token
  Future<User> getUserInfo(String token) async {
    try {
      print('Obteniendo info del usuario desde: $kBaseUrl/me');
      print('Token: ${token.substring(0, 20)}...');
      
      final response = await http.get(
        Uri.parse('$kBaseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('getUserInfo response status: ${response.statusCode}');
      print('getUserInfo response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Error obteniendo información del usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getUserInfo: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/history?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error obteniendo historial');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<String> preguntarMulta(String pregunta, {String? signal}) async {
    try {
      // Solo incluir 'signal' si no es null
      final Map<String, dynamic> body = {
        'question': pregunta,
      };
      
      if (signal != null) {
        body['signal'] = signal;
      }

      print('Enviando solicitud a: $kBaseUrl/chatbot');
      print('Body: $body');

      final response = await http.post(
        Uri.parse('$kBaseUrl/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(
        Duration(seconds: 60), // Aumentar timeout a 60 segundos
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. El servidor se está tardando más de lo esperado.');
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['answer'] ?? 'No se recibió respuesta del servidor';
      } else {
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en preguntarMulta: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> addHistory({
    required int userId,
    String? signalName,
    required String question,
    required String response,
    required DateTime timestamp,
  }) async {
    try {
      final body = {
        'user': {'id': userId},
        'signal': signalName != null ? {'name': signalName} : null,
        'question': question,
        'response': response,
        'timestamp': timestamp.toIso8601String(),
      };

      final responseApi = await http.post(
        Uri.parse('$kBaseUrl/history'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      
      return responseApi.statusCode == 200 || responseApi.statusCode == 201;
    } catch (e) {
      print('Error guardando historial: $e');
      return false;
    }
  }
}
