import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/backend_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  String? _currentSignal; // Almacena la señal actual para el contexto

  String? get currentSignal => _currentSignal;

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
    notifyListeners();

    try {
      final respuesta = await BackendService().preguntarMulta(
        userText, 
        signal: _currentSignal, // Envía la señal actual como contexto
      );
      
      messages.add(ChatMessage(
        text: respuesta,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      messages.add(ChatMessage(
        text: 'Lo siento, hubo un error al procesar tu consulta. Por favor, intenta nuevamente.',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    }

    isLoading = false;
    notifyListeners();
  }
}
