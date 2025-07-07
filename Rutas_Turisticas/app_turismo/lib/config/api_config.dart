import 'package:flutter/foundation.dart';

class ApiConfig {
  // Configuración automática según la plataforma
  static String get apiBase {
    if (kIsWeb) {
      // Para web/navegador
      return 'http://localhost:3000';
    } else {
      // Para emulador Android/iOS
      return 'http://10.0.2.2:3000';
    }
  }
  
  // Para dispositivo físico en la misma red WiFi usar:
  // static const String apiBase = 'http://192.168.1.XXX:3000';
}
