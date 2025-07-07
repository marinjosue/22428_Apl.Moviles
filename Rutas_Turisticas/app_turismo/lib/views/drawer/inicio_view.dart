import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bienvenido a la Guía Turística\nExplora los mejores destinos',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
