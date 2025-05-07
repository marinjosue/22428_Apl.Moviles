import 'package:flutter/material.dart';

class AmigosScreen extends StatefulWidget {
  const AmigosScreen({super.key});

  @override
  State<AmigosScreen> createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen> {
  final TextEditingController aCtrl = TextEditingController();
  final TextEditingController bCtrl = TextEditingController();
  String resultado = '';

  // Método para calcular los divisores propios
  // de un número n (excluyendo el propio número)
  List<int> divisoresPropios(int n) {
    List<int> divisores = [];
    for (int i = 1; i < n; i++) {
      if (n % i == 0) divisores.add(i);
    }
    return divisores;
  }

  // Método para verificar si dos números son amigos
  // (la suma de los divisores propios de A es B y viceversa)
  void verificarAmigos() {
    final a = int.tryParse(aCtrl.text);
    final b = int.tryParse(bCtrl.text);
    // Validar que los números sean válidos, positivos y diferentes
    if (a == null || b == null) {
      setState(() => resultado = 'Por favor, ingrese números válidos.');
      return;
    }
    if (a <= 0 || b <= 0) {
      setState(() => resultado = 'Ambos números deben ser positivos.');
      return;
    }
    if (a == b) {
      setState(() => resultado = 'Los números no deben ser iguales.');
      return;
    }

    final divisoresA = divisoresPropios(a);
    final divisoresB = divisoresPropios(b);
    final sumaA = divisoresA.reduce((value, element) => value + element);
    final sumaB = divisoresB.reduce((value, element) => value + element);

    if (sumaA == b && sumaB == a) {
      resultado =
          'Divisores propios de $a: ${divisoresA.join(', ')} (Suma: $sumaA)\n'
          'Divisores propios de $b: ${divisoresB.join(', ')} (Suma: $sumaB)\n'
          '$a y $b son números amigos';
    } else {
      resultado =
          'Divisores propios de $a: ${divisoresA.join(', ')} (Suma: $sumaA)\n'
                  'Divisores propios de $b: ${divisoresB.join(', ')} (Suma: $sumaB)\n'
                  '\n'
                  '\t$a y $b NO son números amigos'
              .toUpperCase();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Números Amigos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: aCtrl,
              decoration: const InputDecoration(labelText: 'Número A'),
            ),
            TextField(
              controller: bCtrl,
              decoration: const InputDecoration(labelText: 'Número B'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarAmigos,
              child: const Text('Verificar'),
            ),
            const SizedBox(height: 20),
            Text(resultado, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
