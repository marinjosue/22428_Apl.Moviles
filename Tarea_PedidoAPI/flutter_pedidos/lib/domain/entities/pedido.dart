
import './detalle_pedido.dart';
class Pedido {
  final int? id;
  final String cliente;
  final DateTime fecha;
  final List<DetallePedido> detalles;

  Pedido({
    this.id,
    required this.cliente,
    required this.fecha,
    this.detalles = const [],
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      cliente: json['cliente'],
      fecha: DateTime.parse(json['fecha']),
      detalles: (json['detalles'] as List)
          .map((item) => DetallePedido.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': cliente,
      'fecha': fecha.toIso8601String().split('T')[0],
    };
  }
}