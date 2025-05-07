import 'package:flutter/material.dart';

class NumerosScreen extends StatefulWidget {
  const NumerosScreen({super.key});

  @override
  State<NumerosScreen> createState() => _NumerosScreenState();
}

class _NumerosScreenState extends State<NumerosScreen> {
  final List<int> numeros = [];
  String resultado = '';
  final TextEditingController inputCtrl = TextEditingController();
  // Método para agregar un número a la lista
  // y analizar si se han ingresado 10 números
  void agregarNumero() {
    final num = int.tryParse(inputCtrl.text);
    // Validar que el número sea natural (no negativo)
    if (num == null || num < 0) return;

    setState(() {
      numeros.add(num);
      inputCtrl.clear();
      if (numeros.length == 10) analizar();
    });
  }

  // Método para analizar los números ingresados
  // y calcular los resultados requeridos
  // (menores de 15, mayores de 50, entre 25 y 45, y promedio)
  // Se utiliza un bucle for para recorrer la lista de números
  void analizar() {
    int menores15 = 0, mayores50 = 0, entre25y45 = 0, suma = 0;

    for (int num in numeros) {
      if (num < 15) menores15++;
      if (num > 50) mayores50++;
      if (num >= 25 && num <= 45) entre25y45++;
      suma += num;
    }

    double promedio = suma / 100;
    resultado = '''
    Análisis de Números:
    ------------------------
    Lista ingresada: $numeros
    Menores que 15: $menores15
    Mayores que 50: $mayores50
    Entre 25 y 45: $entre25y45
    Promedio: ${promedio.toStringAsFixed(2)}
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de 10 Números')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: inputCtrl,
              decoration: const InputDecoration(
                labelText: 'Ingresa un número natural',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: agregarNumero,
              child: const Text('Agregar número'),
            ),
            const SizedBox(height: 10),
            Text('Total ingresados: ${numeros.length}'),
            const SizedBox(height: 10),
            Expanded(child: SingleChildScrollView(child: Text(resultado))),
          ],
        ),
      ),
    );
  }
}
