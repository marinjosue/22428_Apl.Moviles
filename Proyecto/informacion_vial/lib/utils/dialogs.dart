import 'package:flutter/material.dart';
import 'constants.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("Cerrar"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}

Future<bool?> showSignalDetectedDialog(BuildContext context, String signalName) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.traffic, color: kPrimaryColor, size: 28),
          SizedBox(width: 10),
          Text("¡Señal Detectada!"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Se ha detectado una señal de:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
            ),
            child: Text(
              signalName.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "¿Te gustaría obtener más información sobre esta señal y sus regulaciones?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text("No, gracias", style: TextStyle(color: Colors.grey[600])),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text("Sí, quiero saber más"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}
