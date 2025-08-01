import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel_interfaz.dart';
import '../viewmodels/propietario_viewmodel_interface.dart';
import 'poliza_view.dart';
import 'usuario_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Consumer<PolizaViewModelInterface>(
            builder: (context, vm, _) => PolizaView(),
          ),
          Consumer<PropietarioViewModelInterface>(
            builder: (context, vm, _) => UsuarioView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const ValueKey('main-navigation'),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Póliza",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Persona",
          ),
        ],
      ),
    );
  }
}