import 'package:flutter/foundation.dart';

class ApiConfig {
  // Configuración automática según la plataforma
  static String get apiBase {
    // Usar siempre el backend
    return 'https://22428-apl-moviles.vercel.app';
  }
}
