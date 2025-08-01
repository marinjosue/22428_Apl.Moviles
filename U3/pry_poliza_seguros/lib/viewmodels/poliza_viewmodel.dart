import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/poliza_model.dart';
import './poliza_viewmodel_interfaz.dart';

class PolizaViewModel extends PolizaViewModelInterface {
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

  final String apiUrl = "http://localhost:9090/bdd_dto/api/poliza";

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
      final poliza = Poliza(
        propietario: propietario,
        valorSeguroAuto: valorSeguroAuto,
        modeloAuto: modeloAuto,
        edadPropietario: edadPropietario,
        accidentes: accidentes,
        costoTotal: costoTotal,
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(poliza.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        costoTotal = data['costoTotal'];
      } else {
        error = "Error del backend: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      error = "Excepción: $e";
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}