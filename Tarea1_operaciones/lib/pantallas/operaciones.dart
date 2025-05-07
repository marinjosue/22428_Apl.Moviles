import 'package:flutter/material.dart';

class OperacionesBasicas extends StatefulWidget {
  const OperacionesBasicas({super.key});
  @override
  // State<OperacionesBasicas> createState() => _OperacionesBasicasState();
  _OperacionesBasicasState createState() {
    print("1. Creando el estado de la pantalla operaciones basicas");
    return _OperacionesBasicasState();
  }
}

class _OperacionesBasicasState extends State<OperacionesBasicas> {
  //declarar y mapear objetos
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  String resultado = "0";

  @override
  void initState() {
    super.initState();
    print(
      "2. Inicializando (initState) el estado de la pantalla operaciones basicas",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("3. didChangeDependencies de la pantalla operaciones basicas");
  }

  @override
  void didUpdateWidget(covariant OperacionesBasicas oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("4. didUpdateWidget de la pantalla operaciones basicas");
  }

  //detencion de salida
  @override
  void deactivate() {
    print("5. deactivate de la pantalla operaciones basicas");
    super.deactivate();
  }

  @override
  void dispose() {
    print("6. dispose de la pantalla operaciones basicas");
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }

  //logica de la pantalla
  void operar(String operacion) {
    double num1 = double.tryParse(num1Controller.text) ?? 0;
    double num2 = double.tryParse(num2Controller.text) ?? 0;
    double respuesta = 0;
    switch (operacion) {
      case "sumar":
        respuesta = num1 + num2;
        break;
      case "restar":
        respuesta = num1 - num2;
        break;
      case "multiplicar":
        respuesta = num1 * num2;
        break;
      case "dividir":
        if (num2 != 0) {
          respuesta = num1 / num2;
        } else {
          print("No se puede dividir entre 0");
          respuesta = 0;
        }
        break;
    }
    setState(() {
      resultado = 'Resultado es: $respuesta';
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Operaciones basicas"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: num1Controller,
              decoration: InputDecoration(
                labelText: "Numero 1",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: num2Controller,
              decoration: InputDecoration(
                labelText: "Numero 2",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => operar('sumar'),
                  child: Text("+"),
                ),
                ElevatedButton(
                  onPressed: () => operar('restar'),
                  child: Text("-"),
                ),
                ElevatedButton(
                  onPressed: () => operar('multiplicar'),
                  child: Text("*"),
                ),
                ElevatedButton(
                  onPressed: () => operar('dividir'),
                  child: Text("/"),
                ),
              ],
            ),
            SizedBox(height: 20),

            Text(resultado, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
