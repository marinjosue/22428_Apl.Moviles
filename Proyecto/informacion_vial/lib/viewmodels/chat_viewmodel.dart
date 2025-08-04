import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/backend_service.dart';
import '../services/user_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  String _loadingMessage = 'Procesando...';
  String? _currentSignal; // Almacena la señal actual para el contexto

  String? get currentSignal => _currentSignal;
  String get loadingMessage => _loadingMessage;

  void addInitialMessage(String signName) {
    messages.clear(); // Limpiar mensajes anteriores
    _currentSignal = signName; // Guardar la señal para futuras consultas
    
    messages.add(ChatMessage(
      text: 'Has detectado una señal de ${signName.toUpperCase()}. ¿Qué te gustaría saber sobre esta señal? Puedo ayudarte con información sobre regulaciones, multas por no respetarla, o cualquier otra consulta relacionada.',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void startNewConversation() {
    messages.clear();
    _currentSignal = null; // No hay señal específica
    
    messages.add(ChatMessage(
      text: '¡Hola! Soy tu asistente de señales de tránsito. Puedes preguntarme sobre cualquier señal de tráfico, regulaciones viales del Ecuador, multas, o cualquier consulta relacionada con el tránsito. ¿En qué puedo ayudarte?',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  Future<void> sendMessage(String userText) async {
    messages.add(ChatMessage(
      text: userText,
      sender: MessageSender.user,  
      timestamp: DateTime.now(),
    ));
    isLoading = true;
    _loadingMessage = 'Enviando consulta...';
    notifyListeners();

    int maxRetries = 3;
    int currentTry = 1;

    while (currentTry <= maxRetries) {
      try {
        if (currentTry > 1) {
          _loadingMessage = 'Reintentando... (${currentTry}/$maxRetries)';
          notifyListeners();
          // Esperar un poco antes de reintentar
          await Future.delayed(Duration(seconds: 2));
        } else {
          _loadingMessage = 'Procesando con IA...';
          notifyListeners();
        }

        final respuesta = await BackendService().preguntarMulta(
          userText, 
          signal: _currentSignal, // Envía la señal actual como contexto
        );
        
        messages.add(ChatMessage(
          text: respuesta,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
        ));

        // Guardar en historial si hay usuario logueado
        final user = UserService.instance.currentUser;
        if (user != null) {
          await BackendService().addHistory(
            userId: user.id!,
            signalName: _currentSignal,
            question: userText,
            response: respuesta,
            timestamp: DateTime.now(),
          );
        }
        
        break; // Salir del bucle si fue exitoso
        
      } catch (e) {
        print('Error en sendMessage (intento $currentTry): $e');
        
        if (currentTry == maxRetries) {
          // Último intento fallido
          messages.add(ChatMessage(
            text: 'Lo siento, el servidor está tardando más de lo esperado. Por favor, verifica tu conexión a internet e intenta nuevamente en unos momentos.',
            sender: MessageSender.bot,
            timestamp: DateTime.now(),
          ));
        } else {
          currentTry++;
        }
      }
    }

    isLoading = false;
    _loadingMessage = 'Procesando...';
    notifyListeners();  
  }
}
