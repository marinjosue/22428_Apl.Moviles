import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../models/chat_message.dart';
import '../models/traffic_sign.dart';
import '../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _initialMessageSent = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);
    
    // Recibe la señal detectada como argumento (puede ser null)
    final TrafficSign? sign = ModalRoute.of(context)?.settings.arguments as TrafficSign?;

    // Si hay señal y no se ha enviado el mensaje inicial, agrégalo
    if (sign != null && !_initialMessageSent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.addInitialMessage(sign.name);
        _initialMessageSent = true;
      });
    } else if (sign == null && !_initialMessageSent) {
      // Si no hay señal, inicia una conversación general
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.startNewConversation();
        _initialMessageSent = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sign != null 
            ? 'Chat: ${sign.name}' 
            : 'Asistente Vial',
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (sign != null)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                vm.startNewConversation();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Conversación reiniciada')),
                );
              },
              tooltip: 'Nueva conversación',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: vm.messages.length,
              itemBuilder: (context, idx) {
                final msg = vm.messages[idx];
                return Align(
                  alignment: msg.sender == MessageSender.user
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: msg.sender == MessageSender.user
                          ? kPrimaryColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: msg.sender == MessageSender.user
                            ? kPrimaryColor.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.sender == MessageSender.user 
                          ? kPrimaryColor 
                          : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (vm.isLoading) 
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      vm.loadingMessage, 
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) => _sendMessage(vm, text.trim()),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(vm, _controller.text.trim()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatViewModel vm, String text) {
    if (text.isNotEmpty && !vm.isLoading) {
      print('Enviando mensaje: $text'); // Para debug
      vm.sendMessage(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
