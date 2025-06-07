import 'package:flutter/material.dart';

class NumerosScreen extends StatefulWidget {
  const NumerosScreen({super.key});

  @override
  State<NumerosScreen> createState() => _NumerosScreenState();
}

class _NumerosScreenState extends State<NumerosScreen> {
  final List<int> numeros = [];
  int cantidadTotal = 0;
  String resultado = '';

  final TextEditingController inputCtrl = TextEditingController();
  final TextEditingController numeroInicial = TextEditingController();

  String? validarNumero(String texto) {
    final numero = int.tryParse(texto);
    if (texto.trim().isEmpty) return 'El campo no puede estar vacío.';
    if (numero == null) return 'Debe ser un número válido.';
    if (numero < 0) return 'No se permiten números negativos.';
    return null;
  }

  void establecerCantidad() {
    final error = validarNumero(numeroInicial.text);
    if (error != null) {
      mostrarAlerta(error);
      return;
    }
    final cantidad = int.parse(numeroInicial.text);
    if (cantidad == 0) {
      mostrarAlerta('Debe ingresar al menos un número.');
      return;
    }
    setState(() {
      cantidadTotal = cantidad;
      numeros.clear();
      resultado = '';
      inputCtrl.clear();
    });
  }

  void agregarNumero() {
    final error = validarNumero(inputCtrl.text);
    if (error != null) {
      mostrarAlerta(error);
      return;
    }

    final num = int.parse(inputCtrl.text);

    if (numeros.length >= cantidadTotal) {
      mostrarAlerta('Ya se ingresaron todos los números requeridos.');
      return;
    }

    setState(() {
      numeros.add(num);
      inputCtrl.clear();
      if (numeros.length == cantidadTotal) analizar();
    });
  }

  void analizar() {
    int menores15 = 0, mayores50 = 0, entre25y45 = 0, suma = 0;

    for (int num in numeros) {
      if (num < 15) menores15++;
      if (num > 50) mayores50++;
      if (num >= 25 && num <= 45) entre25y45++;
      suma += num;
    }

    double promedio = suma / numeros.length;

    setState(() {
      resultado = '''
Análisis de Números:
------------------------
Lista ingresada: $numeros
Menores que 15: $menores15
Mayores que 50: $mayores50
Entre 25 y 45: $entre25y45
Promedio: ${promedio.toStringAsFixed(2)}
''';
    });
  }

  void mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void reiniciar() {
    setState(() {
      numeros.clear();
      cantidadTotal = 0;
      resultado = '';
      inputCtrl.clear();
      numeroInicial.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final seAlcanzoLimite = numeros.length >= cantidadTotal && cantidadTotal > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Números')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: numeroInicial,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de números a ingresar',
                    ),
                    enabled: numeros.isEmpty,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: numeros.isEmpty ? establecerCantidad : null,
                  child: const Text('Establecer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
    ),

            const SizedBox(height: 10),
            TextField(
              controller: inputCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa un número natural',
              ),
              enabled: cantidadTotal > 0 && !seAlcanzoLimite,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: (!seAlcanzoLimite && cantidadTotal > 0) ? agregarNumero : null,
              child: const Text('Agregar número'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),
            Text('Total ingresados: ${numeros.length} / $cantidadTotal'),

            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(resultado),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: reiniciar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
