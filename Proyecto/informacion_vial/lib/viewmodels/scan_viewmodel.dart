import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../services/yolo_service.dart';
import '../models/traffic_sign.dart';
import '../utils/dialogs.dart';
import '../utils/constants.dart';

class ScanViewModel extends ChangeNotifier {
  final YoloService _yoloService = YoloService();
  String? _detectedSignal;
  bool _isLoading = false;
  bool _modelLoaded = false;
  String? _modelError;

  String? get detectedSignal => _detectedSignal;
  bool get isLoading => _isLoading;
  String? get modelError => _modelError;

  Future<void> _ensureModelLoaded() async {
    if (!_modelLoaded) {
      try {
        await _yoloService.loadModel();
        _modelLoaded = true;
        _modelError = null;
        print('✅ Modelo cargado exitosamente en ViewModel');
      } catch (e) {
        _modelError = 'Error al cargar el modelo: $e';
        _modelLoaded = false;
        print('❌ Error cargando modelo en ViewModel: $e');
        throw e; // Re-throw para manejar en detectSignal
      }
    }
  }

  Future<void> detectSignal(ui.Image image, BuildContext context) async {
    _isLoading = true;
    _detectedSignal = null;
    notifyListeners();

    try {
      await _ensureModelLoaded(); // ✅ Aquí nos aseguramos de cargar el modelo

      if (!_modelLoaded) {
        throw Exception('El modelo no pudo ser cargado');
      }

      final results = await _yoloService.runModel(image);
      if (results.isNotEmpty) {
        _detectedSignal = results.first;
        print('✅ Señal detectada: $_detectedSignal');
        
        // Mostrar modal de confirmación
        final shouldNavigateToChat = await showSignalDetectedDialog(context, _detectedSignal!);
        
        if (shouldNavigateToChat == true) {
          // Crear objeto TrafficSign y navegar al chat dentro del HomeScreen
          final trafficSign = TrafficSign(
            name: _detectedSignal!,
            type: "detected", // Tipo por defecto
            imageUrl: "", // URL vacía por ahora
          );
          
          // En lugar de navegar a una nueva pantalla, vamos a la tab del chat en HomeScreen
          // y pasamos la señal como argumento global
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacementNamed(
            context,
            kRouteHome,
            arguments: {'chatSignal': trafficSign, 'initialTab': 1}, // Tab 1 es el chat
          );
        }
      } else {
        _detectedSignal = null;
        print('⚠️ No se detectó ninguna señal.');
      }
    } catch (e, s) {
      print('❌ Error en detección: $e');
      print(s);
      _detectedSignal = null;
      _modelError = 'Error en detección: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearDetection() {
    _detectedSignal = null;
    _modelError = null;
    notifyListeners();
  }

  void resetModel() {
    _modelLoaded = false;
    _modelError = null;
    _detectedSignal = null;
    notifyListeners();
  }
}
