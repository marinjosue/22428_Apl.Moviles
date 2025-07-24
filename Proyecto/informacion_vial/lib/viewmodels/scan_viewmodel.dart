import 'package:flutter/material.dart';
import '../services/yolo_service.dart';
import '../models/traffic_sign.dart';

class ScanViewModel extends ChangeNotifier {
  TrafficSign? lastSign;
  bool isScanning = false;

  Future<void> scanSignal() async {
    isScanning = true;
    notifyListeners();
    final nombre = await YoloService().detectarSenal();
    // Puedes mapear el nombre a una imagen o tipo real
    lastSign = TrafficSign(
      name: nombre,
      type: "Reglamentaria",
      imageUrl: "assets/senal_pare.png",
    );
    isScanning = false;
    notifyListeners();
  }
}
