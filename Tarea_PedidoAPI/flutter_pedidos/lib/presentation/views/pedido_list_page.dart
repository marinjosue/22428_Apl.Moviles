import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';
import 'pedido_detail_page.dart';
import 'create_pedido_page.dart';

class PedidoListPage extends StatefulWidget {
  @override
  _PedidoListPageState createState() => _PedidoListPageState();
}

class _PedidoListPageState extends State<PedidoListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PedidoProvider>(context, listen: false).cargarPedidos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Gestión de Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => Provider.of<PedidoProvider>(context, listen: false).cargarPedidos(),
          ),
        ],
      ),
      body: Consumer<PedidoProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando pedidos...', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          if (provider.pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No hay pedidos registrados',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear tu primer pedido',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.cargarPedidos,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: provider.pedidos.length,
              itemBuilder: (context, index) {
                final pedido = provider.pedidos[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      pedido.cliente,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.shopping_basket, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              '${pedido.detalles.length} productos',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PedidoDetailPage(pedido: pedido),
                        ),
                      );
                      // Refresh the list when returning from detail page
                      Provider.of<PedidoProvider>(context, listen: false).cargarPedidos();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePedidoPage()),
          );
          // The list will automatically refresh due to the provider's cargarPedidos call in crearPedido
        },
        icon: Icon(Icons.add),
        label: Text('Nuevo Pedido'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
