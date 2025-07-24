// Puedes implementar TFLite/YOLO real aquí. Por ahora, simula detección.
class YoloService {
  Future<String> detectarSenal() async {
    // Simula la detección de una señal
    await Future.delayed(Duration(seconds: 2));
    return "PARE";
  }
}
