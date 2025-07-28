import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/backend_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  bool isLoading = false;

  void addInitialMessage(String signName) {
    messages.clear(); // Limpiar mensajes anteriores
    messages.add(ChatMessage(
      text: 'Has enfocado una señal de ${signName.toUpperCase()}. ¿Quieres saber multas por no respetarla?',
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

    final respuesta = await BackendService().preguntarMulta(userText);
    messages.add(ChatMessage(
      text: respuesta,
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    ));
    isLoading = false;
    notifyListeners();
  }
}
