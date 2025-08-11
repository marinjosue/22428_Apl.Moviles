// detalle_propietario_viewmodel.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/detalle_propietario_model.dart';

class DetallePropietarioViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  DetallePropietario? _detalle;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DetallePropietario? get detalle => _detalle;

  Future<void> cargarDetallePorUsuario(int usuarioId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://poliza-backend.onrender.com/bdd_dto/api/poliza/usuario?id=$usuarioId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _detalle = DetallePropietario.fromJson(data);
      } else {
        _error = 'Error al cargar detalle del propietario';
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
