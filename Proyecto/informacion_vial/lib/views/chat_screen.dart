import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../models/chat_message.dart';
import '../models/traffic_sign.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _initialMessageSent = false;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);
    final controller = TextEditingController();
    
    // Recibe la señal detectada como argumento
    final TrafficSign? sign = ModalRoute.of(context)?.settings.arguments as TrafficSign?;

    // Si hay señal y no se ha enviado el mensaje inicial, agrégalo
    if (sign != null && !_initialMessageSent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.addInitialMessage(sign.name);
        _initialMessageSent = true;
      });
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                    decoration: BoxDecoration(
                      color: msg.sender == MessageSender.user
                          ? Colors.blue[50]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          if (vm.isLoading) LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      vm.sendMessage(controller.text.trim());
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
