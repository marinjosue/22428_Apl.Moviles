import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    if (!authVM.isAuthenticated) {
      return const Center(
        child: Text('Inicia sesión para ver tu perfil'),
      );
    }

    final usuario = authVM.usuario!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Perfil del Viajero', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(usuario['name']),
            subtitle: const Text('Nombre'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(usuario['email']),
            subtitle: const Text('Correo electrónico'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text('${usuario['favoritos']?.length ?? 0} lugares favoritos'),
            subtitle: const Text('Guardados'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              onPressed: () {
                authVM.logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
