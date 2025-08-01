import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scan_viewmodel.dart';

class RealtimeDetectionScreen extends StatefulWidget {
  const RealtimeDetectionScreen({super.key});

  @override
  State<RealtimeDetectionScreen> createState() => _RealtimeDetectionScreenState();
}

class _RealtimeDetectionScreenState extends State<RealtimeDetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0], // Usar la primera cámara (generalmente la trasera)
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
          _startRealtimeDetection();
        }
      }
    } catch (e) {
      print('Error inicializando cámara: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inicializando cámara: $e')),
        );
      }
    }
  }

  void _startRealtimeDetection() {
    _detectionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isCameraInitialized && !_isDetecting) {
        _captureAndDetect();
      }
    });
  }

  void _stopRealtimeDetection() {
    _detectionTimer?.cancel();
  }

  Future<void> _captureAndDetect() async {
    if (!_isCameraInitialized || _isDetecting) return;

    setState(() {
      _isDetecting = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ui.Image uiImage = frame.image;

      final viewModel = context.read<ScanViewModel>();
      await viewModel.detectSignal(uiImage, context);
    } catch (e) {
      print('Error en detección en tiempo real: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDetecting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _stopRealtimeDetection();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScanViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detección en Tiempo Real'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Vista de la cámara
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Inicializando cámara...'),
                ],
              ),
            ),

          // Overlay con información de detección
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isDetecting ? Icons.search : Icons.visibility,
                        color: _isDetecting ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isDetecting ? 'Analizando...' : 'Buscando señales',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (vm.detectedSignal != null) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white54),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.traffic,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Señal detectada: ${vm.detectedSignal}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (vm.modelError != null) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white54),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Error: ${vm.modelError}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Botones de control
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "clear",
                  onPressed: () => vm.clearDetection(),
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.clear, color: Colors.white),
                ),
                FloatingActionButton.extended(
                  heroTag: "capture",
                  onPressed: _captureAndDetect,
                  backgroundColor: Colors.blue,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    'Detectar Ahora',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "reset",
                  onPressed: () => vm.resetModel(),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
