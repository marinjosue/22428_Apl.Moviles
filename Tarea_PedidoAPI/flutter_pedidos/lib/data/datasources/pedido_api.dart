import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/pedido.dart';

class PedidoApi {
  final String baseUrl = 'http://localhost:8080'; // o localhost si pruebas en navegador

  Future<List<Pedido>> getPedidos() async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Pedido.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener pedidos');
    }
  }

  Future<Pedido> getPedidoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Pedido.fromJson(data);
    } else {
      throw Exception('Error al obtener el pedido');
    }
  }

  Future<void> crearPedido(String cliente, String fecha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cliente': cliente, 'fecha': fecha}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear pedido');
    }
  }

  Future<void> agregarDetalle(int pedidoId, String producto, int cantidad, double precio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos/$pedidoId/detalles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'producto': producto,
        'cantidad': cantidad,
        'precio': precio,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al agregar detalle');
    }
  }
}
