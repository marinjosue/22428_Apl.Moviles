import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../bottomnav/bottom_navigation.dart';
import 'rutas_view.dart';
import 'perfil_view.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  int _drawerIndex = 0;

  final List<Widget> _screens = [
    BottomNavigation(), // Inicio con barra inferior
    RutasView(),
    PerfilView(),
  ];

  final List<String> _titles = [
    'Inicio',
    'Rutas recomendadas',
    'Perfil del viajero',
  ];

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_drawerIndex]),
        actions: [
          if (authVM.isAuthenticated)
            IconButton(
              onPressed: () {
                authVM.logout();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person_pin, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    authVM.usuario?['name'] ?? 'Invitado',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    authVM.usuario?['email'] ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _drawerIndex == 0,
              onTap: () {
                setState(() => _drawerIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Rutas recomendadas'),
              selected: _drawerIndex == 1,
              onTap: () {
                setState(() => _drawerIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil del viajero'),
              selected: _drawerIndex == 2,
              onTap: () {
                setState(() => _drawerIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_drawerIndex],
    );
  }
}
