import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora CLS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculadoraPage(title: 'Calculadora CLS'),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key, required this.title});

  final String title;

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  // Controladores para los campos de texto
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _costoKwController = TextEditingController();
  final TextEditingController _precioArticuloController = TextEditingController();
  
  // Variables para almacenar resultados
  double _pagoEnergia = 0.0;
  double _precioConDescuento = 0.0;
  double _precioFinal = 0.0;
  bool _mostrarResultadosEnergia = false;
  bool _mostrarResultadosArticulo = false;

  @override
  void dispose() {
    // Limpiamos los controladores cuando se destruye el widget
    _consumoController.dispose();
    _costoKwController.dispose();
    _precioArticuloController.dispose();
    super.dispose();
  }

  // Método para calcular el costo del consumo de energía eléctrica
  void _calcularPagoEnergia() {
    try {
      double consumoKW = double.parse(_consumoController.text);
      double costoPorKW = double.parse(_costoKwController.text);
      
      setState(() {
        _pagoEnergia = consumoKW * costoPorKW;
        _mostrarResultadosEnergia = true;
      });
    } catch (e) {
      _mostrarError('Por favor ingrese valores numéricos válidos');
    }
  }

  // Método para calcular el precio final de un artículo con descuento e IVA
  void _calcularPrecioArticulo() {
    try {
      double precioOriginal = double.parse(_precioArticuloController.text);
      
      double descuento = precioOriginal * 0.20; // 20% de descuento
      double precioConDescuento = precioOriginal - descuento;
      double iva = precioConDescuento * 0.15; // 15% de IVA
      double precioFinal = precioConDescuento + iva;
      
      setState(() {
        _precioConDescuento = precioConDescuento;
        _precioFinal = precioFinal;
        _mostrarResultadosArticulo = true;
      });
    } catch (e) {
      _mostrarError('Por favor ingrese un precio válido');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de cálculo de energía eléctrica
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Cálculo de Consumo Eléctrico (CLS)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _consumoController,
                      decoration: const InputDecoration(
                        labelText: 'Consumo en KW',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _costoKwController,
                      decoration: const InputDecoration(
                        labelText: 'Costo por KW (en dolares)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calcularPagoEnergia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Calcular Pago de Energía'),
                    ),
                    if (_mostrarResultadosEnergia) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Pago por consumo eléctrico: \$${_pagoEnergia.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sección de cálculo de precio de artículo
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Cálculo de Precio Final de Artículo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '(Con 20% de descuento y 15% de IVA)',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _precioArticuloController,
                      decoration: const InputDecoration(
                        labelText: 'Precio original del artículo',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calcularPrecioArticulo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Calcular Precio Final'),
                    ),
                    if (_mostrarResultadosArticulo) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio con descuento (20%): \$${_precioConDescuento.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Precio final (con 15% IVA): \$${_precioFinal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}