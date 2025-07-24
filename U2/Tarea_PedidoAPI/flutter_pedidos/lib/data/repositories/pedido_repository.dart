import '../datasources/pedido_api.dart';
import '../../domain/entities/pedido.dart';

class PedidoRepository {
  final PedidoApi api = PedidoApi();

  Future<List<Pedido>> fetchPedidos() => api.getPedidos();
  
  Future<Pedido> fetchPedidoById(int id) => api.getPedidoById(id);
  
  Future<void> addPedido(String cliente, String fecha) =>
      api.crearPedido(cliente, fecha);
      
  Future<void> addDetalle(int pedidoId, String producto, int cantidad, double precio) =>
      api.agregarDetalle(pedidoId, producto, cantidad, precio);
}
