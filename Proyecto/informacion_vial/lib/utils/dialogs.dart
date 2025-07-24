import 'package:flutter/material.dart';

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
