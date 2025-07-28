import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imageLib;


class YoloService {
  Interpreter? _interpreter;
  late List<String> _labels;
  final int inputSize = 640;
  bool _isModelLoaded = false;

  bool get isModelLoaded => _isModelLoaded;

  Future<void> loadModel() async {
    try {
      print('🔄 Iniciando carga del modelo TensorFlow Lite...');
      
      // Método 1: Cargar desde ByteData (recomendado para TensorFlow Lite)
      try {
        print('📁 Cargando asset como ByteData...');
        final ByteData assetData = await rootBundle.load('assets/best-fp16.tflite');
        print('✅ Asset cargado. Tamaño: ${assetData.lengthInBytes} bytes');
        
        // Crear intérprete desde ByteData
        _interpreter = Interpreter.fromBuffer(assetData.buffer.asUint8List());
        print('✅ Intérprete creado desde ByteData');
      } catch (e1) {
        print('❌ Error con ByteData: $e1');
        
        // Método 2: Cargar directamente desde asset (método alternativo)
        try {
          print('📁 Intentando cargar directamente desde asset...');
          _interpreter = await Interpreter.fromAsset('assets/best-fp16.tflite');
          print('✅ Intérprete creado desde asset directo');
        } catch (e2) {
          print('❌ Error con asset directo: $e2');
          
          // Método 3: Sin prefijo assets/
          try {
            _interpreter = await Interpreter.fromAsset('best-fp16.tflite');
            print('✅ Intérprete creado sin prefijo assets/');
          } catch (e3) {
            print('❌ Error sin prefijo: $e3');
            throw Exception('No se pudo cargar el modelo con ningún método. ByteData: $e1, Asset directo: $e2, Sin prefijo: $e3');
          }
        }
      }

      // Verificar información del modelo
      print('📊 Output tensors: ${_interpreter!.getOutputTensors().length}');

      // Cargar las etiquetas
      print('📁 Cargando etiquetas desde assets/labels.txt');
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').where((label) => label.isNotEmpty).toList();
      print('✅ Etiquetas cargadas: ${_labels.length} etiquetas');
      
      // Mostrar algunas etiquetas para debug
      if (_labels.isNotEmpty) {
        print('🏷️ Primeras etiquetas: ${_labels.take(5).join(', ')}');
      }
      
      _isModelLoaded = true;
      print('✅ Modelo completamente inicializado y listo para usar');
    } catch (e) {
      print('❌ Error detallado al cargar modelo: $e');
      _isModelLoaded = false;
      _interpreter = null;
      throw Exception('No se pudo cargar el modelo: $e');
    }
  }

  Future<List<String>> runModel(ui.Image image) async {
    try {
      // Verificar que el modelo esté cargado
      if (_interpreter == null || !_isModelLoaded) {
        throw Exception('El modelo no está inicializado. Llama a loadModel() primero.');
      }

      print('🔄 Ejecutando inferencia...');
      print('📸 Imagen de entrada: ${image.width}x${image.height}');
      
      // Preprocesar la imagen
      final inputData = await _preprocessImage(image);
      print('📊 Datos de entrada preparados: ${inputData.length}x${inputData[0].length}x${inputData[0][0].length}x${inputData[0][0][0].length}');

      // Verificar formato de entrada
      final inputTensor = _interpreter!.getInputTensor(0);
      print('🔍 Verificando formato de entrada:');
      print('   Tensor esperado: ${inputTensor.shape}');
      print('   Datos actuales: [${inputData.length}, ${inputData[0].length}, ${inputData[0][0].length}, ${inputData[0][0][0].length}]');
      
      if (inputData.length != inputTensor.shape[0] ||
          inputData[0].length != inputTensor.shape[1] ||
          inputData[0][0].length != inputTensor.shape[2] ||
          inputData[0][0][0].length != inputTensor.shape[3]) {
        print('❌ ERROR: Forma de entrada no coincide!');
        throw Exception('Formato de entrada incorrecto');
      } else {
        print('✅ Formato de entrada correcto');
      }

      // Preparar salida
      final outputTensor = _interpreter!.getOutputTensors()[0];
      print('📤 Tensor de salida - Shape: ${outputTensor.shape}, Type: ${outputTensor.type}, Elements: ${outputTensor.numElements()}');
      
      final outputData = List.filled(outputTensor.numElements(), 0.0).reshape(outputTensor.shape);

      // Ejecutar inferencia
      _interpreter!.run(inputData, outputData);

      // Debug: mostrar información de la salida
      print('📋 Salida del modelo - Tipo: ${outputData.runtimeType}');
      print('📋 Salida del modelo - Shape: ${outputData.length}');
      if (outputData.isNotEmpty && outputData[0] is List) {
        print('📋 Primera dimensión: ${outputData[0].length}');
        if (outputData[0].isNotEmpty && outputData[0][0] is List) {
          print('📋 Segunda dimensión: ${outputData[0][0].length}');
        }
      }

      // Procesar resultados
      final results = _processOutput(outputData);
      print('✅ Inferencia completada. Resultados: ${results.length}');
      
      return results;
    } catch (e, stackTrace) {
      print('❌ Error en detección: $e');
      print(stackTrace);
      return [];
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(ui.Image image) async {
    print('🖼️ Preprocesando imagen: ${image.width}x${image.height}');
    
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final rgbaBytes = byteData!.buffer.asUint8List();

    // Convertir a Image de la librería image
    final imageLib.Image originalImage = imageLib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: rgbaBytes.buffer,
      format: imageLib.Format.uint8,
      numChannels: 4,
    );

    // Redimensionar la imagen a 640x640 (tamaño de entrada del modelo)
    final resizedImage = imageLib.copyResize(
      originalImage,
      width: inputSize,
      height: inputSize,
      interpolation: imageLib.Interpolation.linear,
    );
    
    print('🔄 Imagen redimensionada a: ${resizedImage.width}x${resizedImage.height}');

    // Normalizar valores de píxeles
    // Formato: [batch_size, height, width, channels] = [1, 640, 640, 3]
    final input = List.generate(
      1, // batch size
      (batch) => List.generate(
        inputSize, // height
        (y) => List.generate(
          inputSize, // width  
          (x) => List.generate(
            3, // RGB channels
            (c) {
              final pixel = resizedImage.getPixel(x, y);
              double value;
              switch (c) {
                case 0:
                  value = pixel.r / 255.0; // Red [0-1]
                  break;
                case 1:
                  value = pixel.g / 255.0; // Green [0-1]
                  break;
                case 2:
                  value = pixel.b / 255.0; // Blue [0-1]
                  break;
                default:
                  value = 0.0;
              }
              return value;
            },
          ),
        ),
      ),
    );

    // Debug: verificar algunos valores
    print('🔍 Muestra de píxeles normalizados:');
    print('   Píxel (0,0): R=${input[0][0][0][0].toStringAsFixed(3)}, G=${input[0][0][0][1].toStringAsFixed(3)}, B=${input[0][0][0][2].toStringAsFixed(3)}');
    print('   Píxel (320,320): R=${input[0][320][320][0].toStringAsFixed(3)}, G=${input[0][320][320][1].toStringAsFixed(3)}, B=${input[0][320][320][2].toStringAsFixed(3)}');
    
    return input;
  }

  List<String> _processOutput(List outputData) {
    try {
      print('🔍 === PROCESANDO SALIDA DEL MODELO ===');
      print('📊 outputData.length: ${outputData.length}');
      print('📊 outputData.runtimeType: ${outputData.runtimeType}');
      
      if (outputData.isEmpty) {
        print('⚠️ outputData está vacío');
        return [];
      }
      
      // Examinar estructura completa
      print('🔍 Analizando estructura de salida...');
      _analyzeOutputStructure(outputData);
      
      // Probar múltiples formatos de YOLO
      return _tryYOLOFormats(outputData);
      
    } catch (e) {
      print('❌ Error procesando salida: $e');
      return [];
    }
  }
  
  void _analyzeOutputStructure(List outputData, [int depth = 0]) {
    const maxDepth = 3;
    if (depth > maxDepth) return;
    
    final indent = '  ' * depth;
    print('${indent}📊 Nivel $depth: length=${outputData.length}, type=${outputData.runtimeType}');
    
    if (outputData.isNotEmpty) {
      final first = outputData[0];
      print('${indent}   Primer elemento: type=${first.runtimeType}');
      
      if (first is List && depth < maxDepth) {
        _analyzeOutputStructure(first, depth + 1);
      } else if (first is num) {
        // Mostrar algunos valores numéricos
        final sample = outputData.take(10).toList();
        print('${indent}   Muestra valores: $sample');
        
        // Estadísticas básicas
        final numbers = outputData.whereType<num>().toList();
        if (numbers.isNotEmpty) {
          final max = numbers.reduce((a, b) => a > b ? a : b);
          final min = numbers.reduce((a, b) => a < b ? a : b);
          final avg = numbers.fold(0.0, (sum, n) => sum + n) / numbers.length;
          print('${indent}   Stats: min=$min, max=$max, avg=${avg.toStringAsFixed(3)}');
        }
      }
    }
  }
  
  List<String> _tryYOLOFormats(List outputData) {
    print('🎯 === PROBANDO FORMATOS YOLO ===');
    
    // Formato 1: [1, num_detections, 85] donde 85 = 4(bbox) + 1(conf) + 80(classes)
    // Pero nuestro modelo tiene 43 clases, así que sería: 4 + 1 + 43 = 48
    try {
      final results = _processYOLOv5Standard(outputData);
      if (results.isNotEmpty) {
        print('✅ Formato YOLOv5 Standard funcionó: ${results.length} detecciones');
        return results;
      }
    } catch (e) {
      print('❌ YOLOv5 Standard falló: $e');
      print('Stack trace: ${StackTrace.current.toString().split('\n').take(5).join('\n')}');
    }
    
    // Formato 2: [1, 85, num_detections] (transpuesto)
    try {
      final results = _processYOLOTransposed(outputData);
      if (results.isNotEmpty) {
        print('✅ Formato YOLO Transpuesto funcionó: ${results.length} detecciones');
        return results;
      }
    } catch (e) {
      print('❌ YOLO Transpuesto falló: $e');
    }
    
    // Formato 3: Clasificación simple (sin bounding boxes)
    try {
      final results = _processAsClassification(outputData);
      if (results.isNotEmpty) {
        print('✅ Formato Clasificación funcionó: ${results.length} clases');
        return results;
      }
    } catch (e) {
      print('❌ Clasificación falló: $e');
    }
    
    // Formato 4: Vector plano
    try {
      final results = _processAsFlattened(outputData);
      if (results.isNotEmpty) {
        print('✅ Formato Plano funcionó: ${results.length} resultados');
        return results;
      }
    } catch (e) {
      print('❌ Formato Plano falló: $e');
    }
    
    print('❌ Ningún formato YOLO funcionó');
    return [];
  }
  
  List<String> _processYOLOv5Standard(List outputData) {
    print('🎯 Procesando formato YOLOv5 Standard: [batch, detections, attributes]');
    print('🔧 DEBUG: Método _processYOLOv5Standard actualizado - versión 2.0');
    
    if (outputData.isEmpty || outputData[0] is! List) {
      throw Exception('Formato inválido para YOLOv5');
    }
    
    final batch = outputData[0] as List;
    print('📊 Batch size: ${outputData.length}, Detecciones: ${batch.length}');
    
    final detectedSigns = <String>[];
    const double confidenceThreshold = 0.001; // Reducido drásticamente 
    const double classThreshold = 0.0003; // Reducido para detectar las señales actuales
    
    print('🔍 Procesando detecciones con umbrales: obj=$confidenceThreshold, class=$classThreshold');
    
    int processedCount = 0;
    int validObjectnessCount = 0;
    double maxObjectnessFound = 0.0;
    double maxClassScoreFound = 0.0;
    
    for (int i = 0; i < batch.length; i++) {
      if (batch[i] is! List) continue;
      
      final detection = batch[i] as List;
      if (detection.length < 48) continue; // Necesitamos 48 elementos (4+1+43)
      
      processedCount++;
      
      // Log inmediato para las primeras 5 detecciones
      if (i < 5) {
        print('🔧 DEBUG: Procesando detección $i de ${detection.length} elementos');
      }
      
      try {
        // YOLO formato: [x_center, y_center, width, height, objectness, class_0, class_1, ..., class_42]
        final double objectness = detection[4].toDouble();
        
        // Log inmediato del objectness
        if (i < 5) {
          print('🔧 DEBUG: Det $i objectness = ${objectness.toStringAsFixed(6)}');
        }
        
        // Actualizar estadísticas
        if (objectness > maxObjectnessFound) {
          maxObjectnessFound = objectness;
        }
        
        if (objectness >= confidenceThreshold) {
          validObjectnessCount++;
        }
        
        if (objectness < confidenceThreshold) continue;
        
        // Buscar la clase con mayor confianza
        double maxClassScore = 0.0;
        int bestClassIndex = -1;
        
        // Las clases empiezan en el índice 5 y tenemos 43 clases
        for (int j = 5; j < 48; j++) {
          final double classScore = detection[j].toDouble();
          if (classScore > maxClassScore) {
            maxClassScore = classScore;
            bestClassIndex = j - 5;
          }
        }
        
        // Actualizar estadística de class score
        if (maxClassScore > maxClassScoreFound) {
          maxClassScoreFound = maxClassScore;
        }
        
        final double finalConfidence = objectness * maxClassScore;
        
        // Log detallado para las primeras detecciones
        if (i < 20 && objectness > 0.001) { // Mostrar más detecciones con objectness mínimo
          print('🔍 Det $i: obj=${objectness.toStringAsFixed(4)}, '
                'bestClass=$bestClassIndex, classScore=${maxClassScore.toStringAsFixed(4)}, '
                'final=${finalConfidence.toStringAsFixed(4)}');
          
          if (bestClassIndex >= 0 && bestClassIndex < _labels.length) {
            print('    -> Clase: ${_labels[bestClassIndex]}');
          }
        }
        
        if (finalConfidence > classThreshold && bestClassIndex >= 0 && bestClassIndex < _labels.length) {
          final String label = _labels[bestClassIndex];
          detectedSigns.add(label);
          print('✅ DETECTADO: $label (confianza: ${finalConfidence.toStringAsFixed(6)})');
          print('    📍 Detalles: obj=${objectness.toStringAsFixed(4)}, class=${maxClassScore.toStringAsFixed(4)}, índice=$bestClassIndex');
        }
        
      } catch (e) {
        if (i < 5) print('❌ Error procesando detección $i: $e');
      }
    }
    
    // Mostrar estadísticas del procesamiento
    print('📊 ESTADÍSTICAS DE PROCESAMIENTO:');
    print('   Detecciones procesadas: $processedCount');
    print('   Con objectness >= $confidenceThreshold: $validObjectnessCount');
    print('   Max objectness encontrado: ${maxObjectnessFound.toStringAsFixed(4)}');
    print('   Max class score encontrado: ${maxClassScoreFound.toStringAsFixed(4)}');
    
    print('🎯 YOLOv5 Standard: ${detectedSigns.length} señales detectadas');
    
    // Si no encontramos nada, mostrar las mejores detecciones para debugging
    if (detectedSigns.isEmpty) {
      print('🔍 === ANÁLISIS DE MEJORES DETECCIONES ===');
      try {
        _findBestDetections(batch);
      } catch (e, stackTrace) {
        print('❌ Error en _findBestDetections: $e');
        print('Stack trace: $stackTrace');
      }
    }
    
    return detectedSigns;
  }
  
  List<String> _processYOLOTransposed(List outputData) {
    print('🔄 Procesando formato YOLO Transpuesto: [batch, attributes, detections]');
    
    if (outputData.isEmpty || outputData[0] is! List) {
      throw Exception('Formato inválido para YOLO transpuesto');
    }
    
    final batch = outputData[0] as List;
    if (batch.length < 5) {
      throw Exception('Insuficientes atributos para YOLO transpuesto');
    }
    
    // En formato transpuesto: batch[0] = x_centers, batch[1] = y_centers, etc.
    final attributes = batch[0] as List;  // Tomar el primer atributo para determinar num_detections
    final numDetections = attributes.length;
    
    print('📊 Atributos: ${batch.length}, Detecciones: $numDetections');
    
    final detectedSigns = <String>[];
    const double confidenceThreshold = 0.2;
    const double classThreshold = 0.3;
    
    for (int i = 0; i < numDetections; i++) {
      try {
        // Extraer objectness (índice 4)
        if (batch.length <= 4 || batch[4] is! List) continue;
        
        final objectnessList = batch[4] as List;
        if (i >= objectnessList.length) continue;
        
        final double objectness = objectnessList[i].toDouble();
        if (objectness < confidenceThreshold) continue;
        
        // Buscar mejor clase (índices 5 en adelante)
        double maxClassScore = 0.0;
        int bestClassIndex = -1;
        
        for (int j = 5; j < batch.length && j - 5 < _labels.length; j++) {
          if (batch[j] is! List) continue;
          
          final classScores = batch[j] as List;
          if (i >= classScores.length) continue;
          
          final double classScore = classScores[i].toDouble();
          if (classScore > maxClassScore) {
            maxClassScore = classScore;
            bestClassIndex = j - 5;
          }
        }
        
        final double finalConfidence = objectness * maxClassScore;
        
        if (i < 10) {
          print('🔍 Det $i: obj=${objectness.toStringAsFixed(3)}, '
                'bestClass=$bestClassIndex, final=${finalConfidence.toStringAsFixed(3)}');
        }
        
        if (finalConfidence > classThreshold && bestClassIndex >= 0 && bestClassIndex < _labels.length) {
          final String label = _labels[bestClassIndex];
          detectedSigns.add(label);
          print('✅ DETECTADO: $label (${finalConfidence.toStringAsFixed(3)})');
        }
        
      } catch (e) {
        if (i < 5) print('❌ Error en detección transpuesta $i: $e');
      }
    }
    
    print('🔄 YOLO Transpuesto: ${detectedSigns.length} señales detectadas');
    return detectedSigns;
  }
  
  void _findBestDetections(List batch) {
    print('🔍 Iniciando búsqueda de mejores detecciones...');
    print('🔍 Batch length: ${batch.length}');
    
    if (batch.isEmpty) {
      print('❌ Batch está vacío');
      return;
    }
    
    List<Map<String, dynamic>> bestDetections = [];
    int validDetections = 0;
    int processedDetections = 0;
    
    // Procesar solo las primeras 500 detecciones para eficiencia
    final maxToProcess = batch.length > 500 ? 500 : batch.length;
    
    for (int i = 0; i < maxToProcess; i++) {
      processedDetections++;
      
      try {
        if (batch[i] is! List) {
          continue;
        }
        
        final detection = batch[i] as List;
        if (detection.length < 48) {
          continue;
        }
        
        final double objectness = (detection[4] as num).toDouble();
        if (objectness <= 0.0005) continue; // Umbral aún más bajo
        
        validDetections++;
        
        // Encontrar mejor clase
        double maxClassScore = 0.0;
        int bestClassIndex = -1;
        
        for (int j = 5; j < 48; j++) {
          final double classScore = (detection[j] as num).toDouble();
          if (classScore > maxClassScore) {
            maxClassScore = classScore;
            bestClassIndex = j - 5;
          }
        }
        
        final double finalConfidence = objectness * maxClassScore;
        
        bestDetections.add({
          'index': i,
          'objectness': objectness,
          'classScore': maxClassScore,
          'finalConfidence': finalConfidence,
          'classIndex': bestClassIndex,
          'className': bestClassIndex >= 0 && bestClassIndex < _labels.length ? _labels[bestClassIndex] : 'unknown'
        });
        
      } catch (e) {
        if (i < 5) {
          print('❌ Error procesando detección $i: $e');
        }
      }
    }
    
    print('📊 Procesadas: $processedDetections, Válidas: $validDetections');
    
    if (bestDetections.isEmpty) {
      print('❌ No se encontraron detecciones válidas');
      return;
    }
    
    // Ordenar por confianza final
    bestDetections.sort((a, b) => (b['finalConfidence'] as double).compareTo(a['finalConfidence'] as double));
    
    // Mostrar los mejores 25
    final topDetections = bestDetections.take(25).toList();
    print('🏆 TOP ${topDetections.length} DETECCIONES:');
    
    for (int i = 0; i < topDetections.length; i++) {
      final det = topDetections[i];
      final obj = (det['objectness'] as double).toStringAsFixed(4);
      final cls = (det['classScore'] as double).toStringAsFixed(4);
      final fin = (det['finalConfidence'] as double).toStringAsFixed(4);
      
      print('${i + 1}. Det[${det['index']}]: obj=$obj, class=$cls, final=$fin, label=${det['className']}');
    }
    
    // Mostrar estadísticas
    final maxObjectness = bestDetections.map((d) => d['objectness'] as double).reduce((a, b) => a > b ? a : b);
    final maxClassScore = bestDetections.map((d) => d['classScore'] as double).reduce((a, b) => a > b ? a : b);
    final maxFinalConf = bestDetections.map((d) => d['finalConfidence'] as double).reduce((a, b) => a > b ? a : b);
    
    print('📊 ESTADÍSTICAS GENERALES:');
    print('   Max objectness: ${maxObjectness.toStringAsFixed(4)}');
    print('   Max class score: ${maxClassScore.toStringAsFixed(4)}');
    print('   Max final confidence: ${maxFinalConf.toStringAsFixed(4)}');
    print('   Total detecciones válidas: ${bestDetections.length}');
    
    // Mostrar distribución de clases detectadas
    final classDistribution = <String, int>{};
    final speedLimitDetections = <Map<String, dynamic>>[];
    
    for (final det in topDetections) {
      final className = det['className'] as String;
      classDistribution[className] = (classDistribution[className] ?? 0) + 1;
      
      // Filtrar señales de velocidad para análisis especial
      if (className.contains('speed limit')) {
        speedLimitDetections.add(det);
      }
    }
    
    print('📊 CLASES MÁS DETECTADAS EN TOP 25:');
    classDistribution.entries.forEach((entry) {
      print('   ${entry.key}: ${entry.value} veces');
    });
    
    // Mostrar análisis específico de señales de velocidad si las hay
    if (speedLimitDetections.isNotEmpty) {
      print('🚦 ANÁLISIS ESPECÍFICO - SEÑALES DE VELOCIDAD:');
      for (int i = 0; i < speedLimitDetections.length; i++) {
        final det = speedLimitDetections[i];
        print('   ${i + 1}. ${det['className']}: obj=${(det['objectness'] as double).toStringAsFixed(4)}, '
              'class=${(det['classScore'] as double).toStringAsFixed(4)}, '
              'final=${(det['finalConfidence'] as double).toStringAsFixed(6)}');
      }
    } else {
      print('⚠️  NO se encontraron señales de velocidad en el TOP 25');
      print('💡 Verificando si hay alguna señal de velocidad en TODO el conjunto...');
      _searchForSpeedLimitSigns(batch);
    }
  }
  
  void _searchForSpeedLimitSigns(List batch) {
    print('🔍 Buscando específicamente señales de velocidad...');
    
    List<Map<String, dynamic>> speedLimitDetections = [];
    
    for (int i = 0; i < batch.length; i++) {
      if (batch[i] is! List) continue;
      
      final detection = batch[i] as List;
      if (detection.length < 48) continue;
      
      try {
        final double objectness = (detection[4] as num).toDouble();
        if (objectness <= 0.0001) continue; // Umbral extremadamente bajo
        
        // Buscar específicamente en los índices de señales de velocidad
        // speed limit 20 = índice 0, speed limit 30 = índice 1, etc.
        for (int speedIndex = 0; speedIndex < 13; speedIndex++) { // Primeras 13 son speed limits
          if (speedIndex + 5 >= detection.length) break;
          
          final double classScore = (detection[speedIndex + 5] as num).toDouble(); 
          if (classScore > 0.01) { // Umbral muy bajo para class score
            final double finalConf = objectness * classScore;
            
            speedLimitDetections.add({
              'index': i,
              'objectness': objectness,
              'classScore': classScore,
              'finalConfidence': finalConf,
              'className': _labels[speedIndex],
              'speedIndex': speedIndex
            });
          }
        }
      } catch (e) {
        // Ignorar errores
      }
    }
    
    if (speedLimitDetections.isNotEmpty) {
      speedLimitDetections.sort((a, b) => (b['finalConfidence'] as double).compareTo(a['finalConfidence'] as double));
      
      print('🚦 ENCONTRADAS ${speedLimitDetections.length} POSIBLES SEÑALES DE VELOCIDAD:');
      final top10 = speedLimitDetections.take(10).toList();
      
      for (int i = 0; i < top10.length; i++) {
        final det = top10[i];
        print('${i + 1}. ${det['className']}: obj=${(det['objectness'] as double).toStringAsFixed(4)}, '
              'class=${(det['classScore'] as double).toStringAsFixed(4)}, '
              'final=${(det['finalConfidence'] as double).toStringAsFixed(6)}');
      }
    } else {
      print('❌ NO se encontraron señales de velocidad con confianza > 0.01');
    }
  }
  
  List<String> _processAsClassification(List outputData) {
    print('🔍 Procesando como clasificación simple...');
    final results = <String>[];
    
    try {
      // Buscar el vector de probabilidades de clases
      List<double> classProbs = [];
      
      if (outputData.isNotEmpty && outputData[0] is List) {
        final firstLevel = outputData[0] as List;
        if (firstLevel.isNotEmpty && firstLevel[0] is List) {
          // Formato [1][1][43] o similar
          final secondLevel = firstLevel[0] as List;
          classProbs = List<double>.from(secondLevel);
        } else {
          // Formato [1][43] o similar
          classProbs = List<double>.from(firstLevel);
        }
      } else {
        // Formato plano [43]
        classProbs = List<double>.from(outputData);
      }
      
      print('🔍 Vector de probabilidades: length=${classProbs.length}');
      if (classProbs.length >= 5) {
        print('🔍 Primeras 5 probabilidades: ${classProbs.take(5).toList()}');
      }
      
      if (classProbs.length == _labels.length) {
        // Encontrar la clase con mayor probabilidad
        double maxProb = classProbs[0];
        int maxIndex = 0;
        
        for (int i = 1; i < classProbs.length; i++) {
          if (classProbs[i] > maxProb) {
            maxProb = classProbs[i];
            maxIndex = i;
          }
        }
        
        print('🔍 Mayor probabilidad: $maxProb en índice $maxIndex (${_labels[maxIndex]})');
        
        if (maxProb > 0.1) { // Threshold muy bajo para testing
          results.add(_labels[maxIndex]);
          print('✅ Clasificación detectada: ${_labels[maxIndex]} (confianza: $maxProb)');
        }
      }
      
    } catch (e) {
      print('❌ Error en processAsClassification: $e');
    }
    
    return results;
  }
  
  List<String> _processAsFlattened(List outputData) {
    print('🔍 Procesando como vector plano...');
    final results = <String>[];
    
    try {
      if (outputData.length == _labels.length) {
        List<double> probs = List<double>.from(outputData);
        double maxProb = probs[0];
        int maxIndex = 0;
        
        for (int i = 1; i < probs.length; i++) {
          if (probs[i] > maxProb) {
            maxProb = probs[i];
            maxIndex = i;
          }
        }
        
        print('🔍 Vector plano - Mayor probabilidad: $maxProb en índice $maxIndex');
        
        if (maxProb > 0.1) {
          results.add(_labels[maxIndex]);
          print('✅ Vector plano detectado: ${_labels[maxIndex]}');
        }
      }
    } catch (e) {
      print('❌ Error en processAsFlattened: $e');
    }
    
    return results;
  }
}
