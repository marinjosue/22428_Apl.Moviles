import 'package:flutter/material.dart';
import '../../../aplication/usecases/pedido_usecase.dart';
import '../../../domain/entities/pedido.dart';

class PedidoProvider with ChangeNotifier {
  final PedidoUseCase useCase = PedidoUseCase();

  List<Pedido> pedidos = [];
  bool loading = false;
  String? error;

  Future<void> cargarPedidos() async {
    loading = true;
    error = null;
    notifyListeners();
    
    try {
      pedidos = await useCase.obtenerPedidos();
    } catch (e) {
      error = e.toString();
      pedidos = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> crearPedido(String cliente, String fecha) async {
    try {
      await useCase.registrarPedido(cliente, fecha);
      await cargarPedidos();
    } catch (e) {
      throw e;
    }
  }

  Future<void> agregarDetalle(int pedidoId, String producto, int cantidad, double precio) async {
    try {
      await useCase.agregarDetalle(pedidoId, producto, cantidad, precio);
      // Don't reload all pedidos here, let the UI handle specific refreshes
      // This improves performance and user experience
    } catch (e) {
      throw e;
    }
  }

  Future<Pedido?> obtenerPedidoPorId(int id) async {
    try {
      return await useCase.obtenerPedidoPorId(id);
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
