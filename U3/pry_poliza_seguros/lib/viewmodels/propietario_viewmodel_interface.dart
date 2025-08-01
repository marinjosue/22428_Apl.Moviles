import 'package:flutter/material.dart';
import '../models/propietario_model.dart';

abstract class PropietarioViewModelInterface extends ChangeNotifier {
  List<Propietario> get propietarios;
  bool get isLoading;
  String? get error;
  Future<void> cargarPropietarios();
  void setMockData(List<Propietario> mockPropietarios);
}