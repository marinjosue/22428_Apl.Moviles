import '../../domain/entities/pedido.dart';
import '../../data/repositories/pedido_repository.dart';

class PedidoUseCase {
  final PedidoRepository repository = PedidoRepository();

  Future<List<Pedido>> obtenerPedidos() => repository.fetchPedidos();
  
  Future<Pedido> obtenerPedidoPorId(int id) => repository.fetchPedidoById(id);
  
  Future<void> registrarPedido(String cliente, String fecha) =>
      repository.addPedido(cliente, fecha);
      
  Future<void> agregarDetalle(int pedidoId, String producto, int cantidad, double precio) =>
      repository.addDetalle(pedidoId, producto, cantidad, precio);
}
