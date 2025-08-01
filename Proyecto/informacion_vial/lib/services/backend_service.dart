import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

import '../models/traffic_sign.dart';


class BackendService {
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
