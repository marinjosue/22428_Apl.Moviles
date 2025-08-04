import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scan_viewmodel.dart';
import '../widgets/platform_warning_widget.dart';
import 'realtime_detection_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  Future<void> _scanImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final viewModel = context.read<ScanViewModel>();
      await viewModel.detectSignal(image, context, File(pickedFile.path)); // Pasar archivo
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final viewModel = context.read<ScanViewModel>();
      await viewModel.detectSignal(image, context, File(pickedFile.path)); // Pasar archivo
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScanViewModel>();

    return PlatformWarningWidget(
      error: vm.modelError,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detección de Señales'),
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Mostrar imagen capturada si existe
              if (Provider.of<ScanViewModel>(context).lastCapturedImage != null) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Título de imagen capturada
                      Text(
                        'Imagen capturada',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Contenedor de la imagen con tamaño controlado
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          // Imagen dentro de un contenedor con altura fija
                          Container(
                            height: 200, // Altura fija para evitar overflow
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                Provider.of<ScanViewModel>(context).lastCapturedImage!,
                                fit: BoxFit.cover, // Escalar para cubrir espacio disponible
                              ),
                            ),
                          ),
                          // Botón para cerrar la imagen
                          Material(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Provider.of<ScanViewModel>(context, listen: false).clearLastImage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
              
              if (vm.isLoading)
                const CircularProgressIndicator()
              else if (vm.modelError != null)
                Column(
                  children: [
                    const Icon(Icons.error, size: 100, color: Colors.red),
                    const SizedBox(height: 20),
                    Text(
                      'Error del modelo:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vm.modelError!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      onPressed: () => vm.resetModel(),
                    ),
                  ],
                )
              else if (vm.detectedSignal != null)
                Column(
                  children: [
                    const Icon(Icons.traffic, size: 100, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    Text(
                      'Señal detectada:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vm.detectedSignal!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Nueva detección'),
                      onPressed: () => vm.clearDetection(),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text('Presiona el botón para escanear una señal.'),
                    const SizedBox(height: 20),
                  ],
                ),
              const SizedBox(height: 20),
              // Botón para detección en tiempo real
              ElevatedButton.icon(
                icon: const Icon(Icons.videocam),
                label: const Text('Detección en Tiempo Real'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RealtimeDetectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Botón para escanear foto desde cámara
              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Tomar foto'),
                onPressed: () => _scanImage(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              // Botón para cargar imagen desde galería
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Cargar desde galería'),
                onPressed: () => _pickImageFromGallery(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      ), // Cierre del Scaffold
    ); // Cierre del PlatformWarningWidget
  }
}
