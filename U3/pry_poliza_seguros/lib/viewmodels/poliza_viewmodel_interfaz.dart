import 'package:flutter/material.dart';

abstract class PolizaViewModelInterface with ChangeNotifier {
  // Getters
  String get propietario;
  double get valorSeguroAuto;
  String get modeloAuto;
  int get edadPropietario;
  int get accidentes;
  double get costoTotal;
  bool get isLoading;
  String? get error;

  // Setters
  set propietario(String value);
  set valorSeguroAuto(double value);
  set modeloAuto(String value);
  set edadPropietario(int value);
  set accidentes(int value);
  set costoTotal(double value);
  set isLoading(bool value);
  set error(String? value);

  // Métodos
  void nuevo();
  Future<void> calcularPoliza();
}