import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$kBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      // Puedes guardar el token si lo necesitas: jsonDecode(response.body)['access_token']
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String name, String password) async {
    final response = await http.post(
      Uri.parse('$kBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
