import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/text_styles.dart';
import '../theme/button_styles.dart';
import '../theme/color_schemes.dart';
import '../controller/login_controller.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

final controller = LoginController();

class _WelcomePageState extends State<WelcomePage> {
  Map<String, String>? _userDetails;
  List<String> _allUsers = [];
  String _currentUsername = '';
  String _currentPassword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String username =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';
    _currentUsername = username;
    _loadUserData(username);
  }

  Future<void> _loadUserData(String username) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/users.txt');

    if (await file.exists()) {
      final lines = await file.readAsLines();
      for (var line in lines) {
        final parts = line.trim().split(',');
        if (parts.isNotEmpty && parts[0] == username && parts.length >= 9) {
          setState(() {
            _currentPassword = parts[1];
            _userDetails = {
              'Usuario': parts[0],
              'Contraseña': parts[1],
              'Nombres': parts[2],
              'Apellidos': parts[3],
              'Dirección': parts[4],
              'Ciudad': parts[5],
              'Email': parts[6],
              'Teléfono': parts[7],
              'Código Postal': parts[8],
            };
          });
          return;
        }
      }
      setState(() => _userDetails = {'Error': 'Usuario no encontrado'});
    } else {
      setState(() => _userDetails = {'Error': 'No hay usuarios registrados.'});
    }
  }

  Future<void> _loadAllUsers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/users.txt');

    if (await file.exists()) {
      final lines = await file.readAsLines();
      setState(() => _allUsers = lines);
    } else {
      setState(() => _allUsers = ['No hay usuarios registrados.']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorSchemes.primary,
        title: const Text('Bienvenido', style: AppTextStyles.title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Ocupa toda la altura disponible
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColorSchemes.primary, AppColorSchemes.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Dentro del Column
            children: [
              const Text('Datos del Usuario:', style: AppTextStyles.title),
              const SizedBox(height: 10),
              _buildUserDetailsCard(),
              const SizedBox(height: 20),

              // Solo muestra los botones si es josue/admin
              if (_currentUsername == 'Josue' &&
                  _currentPassword == 'admin123') ...[
                ElevatedButton(
                  style: AppButtonStyles.primary,
                  onPressed: _loadAllUsers,
                  child: const Text(
                    'Ver todos los usuarios registrados',
                    style: AppTextStyles.button,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: AppButtonStyles.secondary,
                  onPressed: () {
                    controller.clearAllUsers(context);
                  },
                  child: const Text(
                    'Eliminar todos los usuarios',
                    style: AppTextStyles.button,
                  ),
                ),
              ],

              const SizedBox(height: 20),
              ..._allUsers.map((user) => _buildUserCard(user)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsCard() {
    if (_userDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _userDetails!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildUserCard(String userLine) {
    final parts = userLine.split(',');
    final user = parts.isNotEmpty ? parts[0] : 'Desconocido';
    final pass = parts.length > 1 ? parts[1] : '';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Text(
          'Usuario: $user',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Contraseña: $pass'),
      ),
    );
  }
}
