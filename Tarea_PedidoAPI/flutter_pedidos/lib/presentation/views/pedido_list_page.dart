import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';
import 'pedido_detail_page.dart';
import 'create_pedido_page.dart';
import '../views/styles.dart';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppStyles.gradientBackground(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Encabezado personalizado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gestión de Pedidos',
                      style: AppStyles.headingText(),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        Provider.of<PedidoProvider>(context, listen: false)
                            .cargarPedidos();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Contenedor del listado expandible
                Expanded(
                  child: Consumer<PedidoProvider>(
                    builder: (context, provider, child) {
                      if (provider.loading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text('Cargando pedidos...',
                                  style: AppStyles.bodyText()),
                            ],
                          ),
                        );
                      }

                      if (provider.pedidos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 64, color: Colors.white54),
                              SizedBox(height: 16),
                              Text('No hay pedidos registrados',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white70)),
                              SizedBox(height: 8),
                              Text(
                                'Toca el botón + para crear tu primer pedido',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: provider.cargarPedidos,
                        child: ListView.builder(
                          itemCount: provider.pedidos.length,
                          itemBuilder: (context, index) {
                            final pedido = provider.pedidos[index];
                            return Card(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueGrey[900],
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text(
                                  pedido.cliente,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 16,
                                            color: Colors.indigo.shade900),
                                        SizedBox(width: 4),
                                        Text(
                                          '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}',
                                          style: TextStyle(
                                              color: Colors.indigo.shade900),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_basket,
                                            size: 16,
                                            color: Colors.indigo.shade900),
                                        SizedBox(width: 4),
                                        Text(
                                          '${pedido.detalles.length} productos',
                                          style: TextStyle(
                                              color: Colors.indigo.shade900),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.indigo.shade900),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PedidoDetailPage(pedido: pedido),
                                    ),
                                  );
                                  Provider.of<PedidoProvider>(context,
                                      listen: false)
                                      .cargarPedidos();
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePedidoPage()),
          );
        },
        icon: Icon(Icons.add, color: Colors.black87),
        label: Text('Nuevo Pedido', style: AppStyles.buttonText()),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
