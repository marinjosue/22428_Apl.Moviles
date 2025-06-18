import 'package:flutter/material.dart';

class Validations {
  static void mostrarAlerta(BuildContext context, String mensaje, IconData icono) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icono, color: Colors.red),
            SizedBox(width: 10),
            Text('¡Error!', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  static bool validarSoloLetras(BuildContext context, String texto) {
    final letrasRegExp = RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$');
    if (!letrasRegExp.hasMatch(texto)) {
      mostrarAlerta(context, 'Solo se permiten letras.', Icons.warning_amber);
      return false;
    }
    return true;
  }

  static bool validarEntero(BuildContext context, String texto) {
    final intRegExp = RegExp(r'^\d+$');
    if (!intRegExp.hasMatch(texto)) {
      mostrarAlerta(context, 'Solo se permiten números enteros.', Icons.error_outline);
      return false;
    }
    return true;
  }

  static bool validarMayorACero(BuildContext context, String texto) {
    try {
      final numero = int.parse(texto);
      if (numero <= 0) {
        mostrarAlerta(context, 'El número debe ser mayor a cero.', Icons.cancel);
        return false;
      }
      return true;
    } catch (_) {
      mostrarAlerta(context, 'Ingresa un número válido.', Icons.cancel);
      return false;
    }
  }



  static String? validarNombre(String? value) {
  if (value == null || value.trim().isEmpty) {
  return 'Por favor ingrese el nombre del producto';
  }
  final letrasRegExp = RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$');
  if (!letrasRegExp.hasMatch(value.trim())) {
  return 'Solo se permiten letras en el nombre del producto';
  }
  return null;
  }

  static String? validarCantidad(String? value) {
  if (value == null || value.trim().isEmpty) {
  return 'Por favor ingrese la cantidad';
  }
  final cantidad = int.tryParse(value);
  if (cantidad == null || cantidad <= 0) {
  return 'Ingrese una cantidad válida mayor a 0';
  }
  return null;
  }

  static String? validarPrecio(String? value) {
  if (value == null || value.trim().isEmpty) {
  return 'Por favor ingrese el precio';
  }
  final precio = double.tryParse(value);
  if (precio == null || precio <= 0) {
  return 'Ingrese un precio válido mayor a 0';
  }
  return null;
  }


}
