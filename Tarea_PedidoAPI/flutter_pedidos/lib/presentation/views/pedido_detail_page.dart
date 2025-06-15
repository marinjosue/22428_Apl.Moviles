import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/pedido.dart';
import '../providers/pedido_provider.dart';
import 'add_detalle_page.dart';

class PedidoDetailPage extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetailPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PedidoDetailPageState createState() => _PedidoDetailPageState();
}

class _PedidoDetailPageState extends State<PedidoDetailPage> {
  late Pedido currentPedido;

  @override
  void initState() {
    super.initState();
    currentPedido = widget.pedido;
  }

  Future<void> _refreshPedido() async {
    if (currentPedido.id != null) {
      final provider = Provider.of<PedidoProvider>(context, listen: false);
      final updatedPedido = await provider.obtenerPedidoPorId(currentPedido.id!);
      if (updatedPedido != null) {
        setState(() {
          currentPedido = updatedPedido;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Detalle del Pedido'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPedido,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del pedido
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Información del Cliente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow('Cliente:', currentPedido.cliente),
                    _buildInfoRow('Fecha:', '${currentPedido.fecha.day}/${currentPedido.fecha.month}/${currentPedido.fecha.year}'),
                    _buildInfoRow('ID Pedido:', currentPedido.id?.toString() ?? 'N/A'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Detalles del pedido
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_basket, color: Theme.of(context).primaryColor),
                            SizedBox(width: 8),
                            Text(
                              'Productos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddDetallePage(pedidoId: currentPedido.id!),
                              ),
                            );
                            
                            // Refresh the pedido when returning from AddDetallePage
                            if (result == true) {
                              await _refreshPedido();
                            }
                          },
                          icon: Icon(Icons.add),
                          label: Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    if (currentPedido.detalles.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                            SizedBox(height: 8),
                            Text(
                              'No hay productos en este pedido',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    else
                      ...currentPedido.detalles.map((detalle) => Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detalle.producto,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Cantidad: ${detalle.cantidad}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${detalle.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                  ],
                ),
              ),
            ),
            
            if (currentPedido.detalles.isNotEmpty) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${currentPedido.detalles.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad)).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
