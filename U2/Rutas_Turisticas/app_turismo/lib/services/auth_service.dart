import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class AuthService {
  final String _baseUrl = ApiConfig.apiBase;

  Future<Map<String, dynamic>> register(String uid, String name, String email, String password, [String photoUrl = '']) async {
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
      return {'success': false, 'message': jsonDecode(response.body)['error']};
    }
  }

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
      return {'success': false, 'message': jsonDecode(response.body)['error']};
    }
  }
}