import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class RegistroViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _mensaje;

  bool get isLoading => _isLoading;
  String? get mensaje => _mensaje;

  Future<bool> registrar(String username, String password) async {
    _isLoading = true;
    _mensaje = null;
    notifyListeners();

    final data = Usuario(username: username, password: password);

    try {
      final response = await http.post(
        Uri.parse('https://poliza-backend.onrender.com/bdd_dto/api/registro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _mensaje = 'Registro exitoso';
        return true;
      } else {
        _mensaje = 'Error en el registro';
        return false;
      }
    } catch (e) {
      _mensaje = 'Error de conexión: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
