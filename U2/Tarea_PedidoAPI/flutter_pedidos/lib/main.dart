import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/pedido_provider.dart';
import 'presentation/views/pedido_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PedidoProvider()),
      ],
      child: MaterialApp(
        title: 'Gestión de Pedidos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue[800],
          hintColor: Colors.orange[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        home: PedidoListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
