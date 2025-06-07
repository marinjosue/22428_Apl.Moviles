import 'package:flutter/material.dart';

class VerificarPrimoScreen extends StatelessWidget {
  const VerificarPrimoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Número Primo')),
      body: const Center(
        child: Text('Aquí se verifica si un número es primo.'),
      ),
    );
  }
}
