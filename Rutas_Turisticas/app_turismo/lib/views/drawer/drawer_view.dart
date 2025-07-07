import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bottomnav/bottom_navigation.dart';
import '../auth/login_view.dart';
import 'rutas_view.dart';
import 'perfil_view.dart';
import '../../viewmodels/auth_viewmodel.dart';

class DrawerView extends StatefulWidget {
  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  int _drawerIndex = 0; // 0: Inicio, 1: Rutas, 2: Perfil

  final List<Widget> _drawerScreens = [
    BottomNavigation(), // "Inicio" muestra la navegación inferior
    RutasView(),
    PerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Si no está autenticado, mostrar login
        if (!authViewModel.isAuthenticated) {
          return LoginView();
        }

        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guía Turística',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      SizedBox(height: 10),
                      if (authViewModel.usuario != null)
                        Text(
                          'Hola, ${authViewModel.usuario!.nombre}',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      Text(
                        authViewModel.usuario?.email ?? '',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Inicio'),
                  selected: _drawerIndex == 0,
                  onTap: () {
                    setState(() {
                      _drawerIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.map_outlined),
                  title: Text('Rutas recomendadas'),
                  selected: _drawerIndex == 1,
                  onTap: () {
                    setState(() {
                      _drawerIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Perfil del viajero'),
                  selected: _drawerIndex == 2,
                  onTap: () {
                    setState(() {
                      _drawerIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.favorite_outline),
                  title: Text('Mis favoritos'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a vista de favoritos
                  },
                ),
                ListTile(
                  leading: Icon(Icons.comment_outlined),
                  title: Text('Mis comentarios'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a vista de comentarios del usuario
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _mostrarDialogoCerrarSesion(context, authViewModel);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(['Inicio', 'Rutas recomendadas', 'Perfil del viajero'][_drawerIndex]),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: _drawerScreens[_drawerIndex],
        );
      },
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                authViewModel.signOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
