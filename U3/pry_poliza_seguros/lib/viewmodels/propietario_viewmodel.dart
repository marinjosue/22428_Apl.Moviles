import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pry_poliza_seguros/viewmodels/propietario_viewmodel_interface.dart';
import '../models/propietario_model.dart';

class PropietarioViewModel extends ChangeNotifier implements PropietarioViewModelInterface {
  List<Propietario> _propietarios = [];
  bool _isLoading = false;
  String? _error;

  List<Propietario> get propietarios => _propietarios;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarPropietarios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://poliza-backend.onrender.com/bdd_dto/api/propietarios'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _propietarios =
            jsonList.map((json) => Propietario.fromJson(json)).toList();
      } else {
        _error = 'Error al cargar propietarios (código ${response.statusCode})';
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void setMockData(List<Propietario> mockPropietarios) {
    // En la implementación real puedes dejarlo vacío o lanzar un error
    throw UnsupportedError('setMockData no debe usarse en producción');
  }
}