import 'package:flutter/material.dart';
import 'package:pry_poliza_seguros/viewmodels/poliza_viewmodel_interfaz.dart';

class FakePolizaViewModel extends PolizaViewModelInterface {
  @override
  String propietario = '';

  @override
  double valorSeguroAuto = 0;

  @override
  String modeloAuto = 'A';

  @override
  int edadPropietario = 18;

  @override
  int accidentes = 0;

  @override
  double costoTotal = 0;

  @override
  bool isLoading = false;

  @override
  String? error;

  @override
  void nuevo() {
    propietario = '';
    valorSeguroAuto = 0;
    modeloAuto = 'A';
    edadPropietario = 18;
    accidentes = 0;
    costoTotal = 0;
    error = null;
    isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> calcularPoliza() async {
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      // Validaciones
      if (propietario.isEmpty) {
        error = 'Nombre requerido';
        throw Exception('Nombre requerido');
      }
      if (valorSeguroAuto <= 0) {
        error = 'El valor debe ser positivo';
        throw Exception('Valor inválido');
      }
      if (edadPropietario < 18) {
        error = 'Edad mínima: 18 años';
        throw Exception('Edad inválida');
      }

      // Lógica de cálculo mejorada
      double baseRate = 0.1;
      double modelFactor = switch(modeloAuto) {
        'A' => 1.0,
        'B' => 1.2,
        'C' => 1.5,
        _ => 1.0,
      };

      double ageDiscount = edadPropietario > 25 ? 0.05 : 0;
      double accidentSurcharge = accidentes * 0.02;

      costoTotal = valorSeguroAuto * baseRate * modelFactor *
          (1 - ageDiscount + accidentSurcharge);

    } catch (e) {
      error = e.toString();
      costoTotal = 0;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Métodos para testing
  void setValoresValidos() {
    propietario = 'Usuario Válido';
    valorSeguroAuto = 20000;
    modeloAuto = 'B';
    edadPropietario = 30;
    accidentes = 1;
    costoTotal = 0;
    error = null;
    isLoading = false;
    notifyListeners();
  }

  void setValoresInvalidos() {
    propietario = '';
    valorSeguroAuto = -1000;
    modeloAuto = '';
    edadPropietario = 16;
    accidentes = -5;
    costoTotal = 0;
    error = null;
    isLoading = false;
    notifyListeners();
  }

  void setValoresEdgeCases() {
    propietario = 'X';
    valorSeguroAuto = double.maxFinite;
    modeloAuto = 'C';
    edadPropietario = 18;
    accidentes = 999;
    costoTotal = 0;
    error = null;
    isLoading = false;
    notifyListeners();
  }
}