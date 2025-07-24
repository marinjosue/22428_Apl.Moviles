import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

import '../models/traffic_sign.dart';


class BackendService {
  Future<String> preguntarMulta(String pregunta) async {
    final response = await http.post(
      Uri.parse('$kBaseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': pregunta}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    }
    throw Exception('Error consultando backend');
  }

  Future<List<Map<String, dynamic>>> getHistory(int userId) async {
    final response = await http.get(
      Uri.parse('$kBaseUrl/history?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    throw Exception('Error obteniendo historial');
  }

  Future<bool> addHistory({
    required int userId,
    required TrafficSign? signal,
    required String question,
    required String response,
    required DateTime timestamp,
  }) async {
    final body = {
      'user': {'id': userId},
      'signal': signal != null ? {
        // Si tu modelo TrafficSign tiene un campo id, agrégalo aquí
        'name': signal.name,
        'type': signal.type,
        'imageUrl': signal.imageUrl,
      } : null,
      'question': question,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
    };
    final responseApi = await http.post(
      Uri.parse('$kBaseUrl/history'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return responseApi.statusCode == 200;
  }
}
