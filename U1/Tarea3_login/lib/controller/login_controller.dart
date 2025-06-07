import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../model/login_model.dart';

class LoginController {
  String? vaidarUsuario(String? value) {
    if (value == null || value.isEmpty) {
      return "El campo usuario no puede estar vacío";
    }
    return null;
  }

  String? vaidarClave(String? value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return "El campo clave no puede estar vacío";
    }
    return null;
  }

  /// Valida usuario y clave usando el modelo completo
  Future<String?> validateUserFromFile(String usuario, String clave) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/users.txt');

      if (!await file.exists()) return 'No hay usuarios registrados.';

      final lines = await file.readAsLines();
      for (var line in lines) {
        final user = UsuarioModel.fromCsv(line.trim());
        if (user.username == usuario && user.password == clave) {
          return null; // Login exitoso
        }
      }
      return 'Usuario o clave incorrectos.';
    } catch (e) {
      return 'Error al acceder a los datos.';
    }
  }

  /// Maneja el flujo completo del login
  void login(BuildContext context, String usuario, String clave) async {
    final error = await validateUserFromFile(usuario, clave);

    if (error == null) {
      Navigator.pushNamed(context, '/welcome', arguments: usuario);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  Future<void> clearAllUsers(BuildContext context) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/users.txt');

  if (await file.exists()) {
    await file.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todos los usuarios han sido eliminados')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay usuarios registrados')),
    );
  }
}
}
