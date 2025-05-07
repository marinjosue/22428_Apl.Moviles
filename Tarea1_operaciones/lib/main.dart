import 'package:flutter/material.dart';
import 'pantallas/sueldo_screen.dart';
import 'pantallas/numeros_screen.dart';
import 'pantallas/amigos_screen.dart';
import 'pantallas/serie_screen.dart';
import 'pantallas/operaciones.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Problemas 1.1 - NRC 22428',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaPrincipal(),
        '/sueldo': (context) => const SueldoScreen(),
        '/numeros': (context) => const NumerosScreen(),
        '/amigos': (context) => const AmigosScreen(),
        '/serie': (context) => const SerieScreen(),
        '/Operaciones_Basicas': (context) => const OperacionesBasicas(),
      },
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios de Lógica - NRC 22428')),
      body: Padding(
        padding: const EdgeInsets.all(90.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Problemas 1.1 - NRC 22428',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ejercicios de Lógica',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Integrantes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Josue Marin', style: TextStyle(fontSize: 16)),
            const Text('Mikaela Salcedo', style: TextStyle(fontSize: 16)),
            const Text('Diego Casignia', style: TextStyle(fontSize: 16)),
            const Text(
              'Selecciona un ejercicio:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => Navigator.pushNamed(context, '/Operaciones_Basicas'),
              child: const Text('Ejercicio 1 - Operaciones Básicas'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/sueldo'),
              child: const Text('Ejercicio 16 - Sueldo Semanal'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/numeros'),
              child: const Text('Ejercicio 17 - Análisis de Números'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/amigos'),
              child: const Text('Ejercicio 18 - Números Amigos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/serie'),
              child: const Text('Ejercicio 22 - Serie Exponencial'),
            ),
          ],
        ),
      ),
    );
  }
}
