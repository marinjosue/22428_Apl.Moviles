import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pry_menu_grid_provider/views/sitios/sitio_detalle_view.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../config/api_config.dart';
import '../auth/login_view.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  bool _isLoading = false;
  List<dynamic> _sitiosFavoritos = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    if (!authVM.isAuthenticated || authVM.usuario == null) return;

    final favoritos = authVM.usuario!['favoritos'];
    if (favoritos == null || favoritos.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final sitiosCargados = <dynamic>[];
      
      for (final favId in favoritos) {
        final url = Uri.parse('${ApiConfig.apiBase}/sitios/$favId');
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final sitio = jsonDecode(response.body);
          sitiosCargados.add(sitio);
        }
      }
      
      if (mounted) {
        setState(() {
          _sitiosFavoritos = sitiosCargados;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar favoritos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    if (!authVM.isAuthenticated || authVM.usuario == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            const Text(
              'Debes iniciar sesión para ver tu perfil',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.login, size: 22),
              label: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: Colors.teal.withOpacity(0.5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      );
    }

    final usuario = authVM.usuario!;
    final favoritos = (usuario['favoritos'] ?? []);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
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
              title: Text('${favoritos.length} lugares favoritos'),
              subtitle: const Text('Guardados'),
            ),
            const SizedBox(height: 20),

            // NUEVA SECCIÓN: Lista de favoritos
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_sitiosFavoritos.isNotEmpty) ...[
              const Text('Tus lugares guardados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _sitiosFavoritos.length,
                itemBuilder: (context, index) {
                  final sitio = _sitiosFavoritos[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.place, color: Colors.pink),
                      title: Text(sitio['nombre'] ?? 'Sin nombre'),
                      subtitle: Text(sitio['descripcion'] != null ? 
                        (sitio['descripcion'].length > 60 ? '${sitio['descripcion'].substring(0, 60)}...' : sitio['descripcion'])
                        : ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SitioDetalleView(sitio: sitio),
                          ),
                        ).then((_) => _cargarFavoritos()); // Actualiza al regresar
                      },
                    ),
                  );
                },
              ),
            ] else if (favoritos.isNotEmpty) ...[
              const Text('Cargando tus lugares guardados...', style: TextStyle(color: Colors.grey)),
            ] else ...[
              const Text('No tienes lugares guardados.', style: TextStyle(color: Colors.grey)),
            ],

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Cerrar sesión'),
                      content: Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            authVM.logout();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
