import 'package:flutter/material.dart';
import 'package:pry_poliza_seguros/models/propietario_model.dart';
import 'package:pry_poliza_seguros/viewmodels/propietario_viewmodel_interface.dart';

class FakePropietarioViewModel extends ChangeNotifier implements PropietarioViewModelInterface {
  List<Propietario> propietarios = [];
  bool isLoading = false;
  String? error;

  // Método para configurar datos de prueba
  void setMockPropietarios(List<Propietario> mockData) {
    propietarios = mockData;
    isLoading = false;
    error = null;
    notifyListeners();
  }

  Future<void> cargarPropietarios() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100)); // Simula delay de red

    // Mantiene los datos mockeados que se configuraron con setMockPropietarios
    isLoading = false;
    notifyListeners();
  }

  @override
  void setMockData(List<Propietario> mockPropietarios) {
    propietarios = mockPropietarios;
    isLoading = false;
    error = null;
    notifyListeners();
  }
}