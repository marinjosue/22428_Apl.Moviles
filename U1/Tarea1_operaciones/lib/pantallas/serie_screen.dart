import 'package:flutter/material.dart';

class SerieScreen extends StatefulWidget {
  const SerieScreen({super.key});

  @override
  State<SerieScreen> createState() => _SerieScreenState();
}

class _SerieScreenState extends State<SerieScreen> {
  final TextEditingController xCtrl = TextEditingController();
  final TextEditingController nCtrl = TextEditingController();
  String resultado = '';

  // Método para calcular la serie exponencial
  // e^x = 1 + x/1! + x^2/2! + x^3/3! + ... + x^n/n!
  void calcularSerie() {
    final x = double.tryParse(xCtrl.text);
    final n = int.tryParse(nCtrl.text);
    // Validar que los datos sean válidos
    if (x == null || n == null || n < 0) {
      setState(() => resultado = 'Datos inválidos');
      return;
    }

    double suma = 1;
    double termino = 1;

    for (int i = 1; i <= n; i++) {
      termino *= x / i;
      suma += termino;
    }
    setState(() => resultado = 'Valor de la serie: ${suma.toStringAsFixed(5)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serie Exponencial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: xCtrl, decoration: const InputDecoration(labelText: 'Valor de x')),
            TextField(controller: nCtrl, decoration: const InputDecoration(labelText: 'Valor de n')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calcularSerie, child: const Text('Calcular')),
            const SizedBox(height: 20),
            Text(resultado, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
