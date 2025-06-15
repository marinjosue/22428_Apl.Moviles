
class DetallePedido {
  final int? id;
  final String producto;
  final int cantidad;
  final double precio;

  DetallePedido({
    this.id,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'],
      producto: json['producto'],
      cantidad: json['cantidad'],
      precio: json['precio'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
    };
  }
}