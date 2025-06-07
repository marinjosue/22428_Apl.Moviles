import 'package:flutter/material.dart';

class SueldoScreen extends StatefulWidget {
  const SueldoScreen({super.key});

  @override
  State<SueldoScreen> createState() => _SueldoScreenState();
}

class _SueldoScreenState extends State<SueldoScreen> {
  final TextEditingController edadCtrl = TextEditingController();
  final TextEditingController antiguedadCtrl = TextEditingController();
  String resultado = '';

  // Método para calcular el sueldo semanal
  // Sueldo base: 35000 + edad
  void calcularSueldo() {
    final edad = int.tryParse(edadCtrl.text);
    final antiguedad = int.tryParse(antiguedadCtrl.text);
    // Validar que los datos sean válidos
    if (edad == null || antiguedad == null) {
      setState(
        () => resultado = 'Por favor, ingrese valores numéricos válidos.',
      );
      return;
    }
    if (edad < 18) {
      setState(() => resultado = 'La edad debe ser mayor o igual a 18 años.');
      return;
    }
    if (antiguedad < 0) {
      setState(() => resultado = 'La antigüedad no puede ser negativa.');
      return;
    }
    if (antiguedad > edad) {
      setState(() => resultado = 'La antigüedad no puede ser mayor que la edad.');
      return;
    }
    if (edad > 80) {
      setState(() => resultado = 'ya esta muerto ??.');
      return;
    }
    if (edad == antiguedad) {
      setState(() => resultado = 'Error: La antigüedad no puede ser igual a la edad.');
      return;
    }

    if(edad - antiguedad < 18){
      setState(() => resultado = 'Error: La edad menos la antigüedad no puede ser menor a 18.');
      return;
    }
    // Sueldo base
    int sueldo = 35000 + edad;

    // Suma de 1 a n: n*(n+1)/2
    int sumaAntiguedad = (antiguedad * (antiguedad + 1)) ~/ 2;
    sueldo += sumaAntiguedad * 100;

    setState(() => resultado = 'Sueldo semanal: \$${sueldo}');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de Sueldo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: edadCtrl,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
            TextField(
              controller: antiguedadCtrl,
              decoration: const InputDecoration(
                labelText: 'Antigüedad en años',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularSueldo,
              child: const Text('Calcular Sueldo'),
            ),
            const SizedBox(height: 20),
            Text(resultado, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
