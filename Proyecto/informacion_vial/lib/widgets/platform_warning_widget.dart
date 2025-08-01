import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PlatformWarningWidget extends StatelessWidget {
  final Widget child;
  final String? error;

  const PlatformWarningWidget({
    Key? key,
    required this.child,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si estamos en Windows y hay un error relacionado con TensorFlow Lite
    if (Platform.isWindows && error != null && error!.contains('libtensorflowlite')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Información Importante'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'TensorFlow Lite en Windows',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'La funcionalidad de inteligencia artificial (detección de señales) '
                'no está completamente soportada en Flutter Windows.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Soluciones recomendadas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('• Usa un dispositivo Android físico'),
                    const Text('• Usa un emulador Android'),
                    const Text('• Usa un dispositivo iOS'),
                    const SizedBox(height: 10),
                    const Text(
                      'En estas plataformas, todas las funciones de IA funcionarán perfectamente.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.android),
                      label: const Text('Usar Android'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Instrucciones'),
                            content: const Text(
                              'Para usar Android:\n\n'
                              '1. Conecta un dispositivo Android\n'
                              '2. O usa un emulador Android\n'
                              '3. Ejecuta: flutter run\n'
                              '4. Selecciona el dispositivo Android\n\n'
                              'Todas las funciones de IA funcionarán correctamente.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Entendido'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      onPressed: () {
                        // Esto causará que se reconstruya la pantalla
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => child),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Error técnico: ${error ?? "TensorFlow Lite no compatible"}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // En cualquier otra situación, mostrar el widget normal
    return child;
  }
}
