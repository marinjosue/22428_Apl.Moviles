import '../validators/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/text_styles.dart';
import '../theme/button_styles.dart';
import '../theme/color_schemes.dart';
import '../controller/calculate.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monthsController = TextEditingController(text: '20');
  final TextEditingController _initialPaymentController = TextEditingController(text: '10');

  List<double> payments = [];
  int selectedMonth = -1;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final months = int.tryParse(_monthsController.text) ?? 20;
    final initial = double.tryParse(_initialPaymentController.text) ?? 10;
    setState(() {
      payments = Calculate.exponentialPayments(months, initial);
    });
  }

  double get total => payments.fold(0, (sum, p) => sum + p);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorSchemes.primary,
        title: const Text('Pagos Exponenciales', style: AppTextStyles.title),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColorSchemes.primary, AppColorSchemes.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.monetization_on, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Formulario
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _monthsController,
                            style: AppTextStyles.input,
                            decoration: const InputDecoration(
                              labelText: 'Meses',
                              labelStyle: AppTextStyles.input,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              final intValue = int.tryParse(value);
                              if (intValue == null || intValue <= 0) {
                                return 'Debe ser un número mayor a 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _initialPaymentController,
                            style: AppTextStyles.input,
                            decoration: const InputDecoration(
                              labelText: 'Pago inicial (\$)',
                              labelStyle: AppTextStyles.input,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              final doubleValue = double.tryParse(value);
                              if (doubleValue == null || doubleValue <= 0) {
                                return 'Debe ser un número mayor a 0';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: AppButtonStyles.primary,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _calculate();
                        }
                      },
                      child: const Text('Calcular', style: AppTextStyles.button),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text('Total a pagar: \$${total.toStringAsFixed(2)}',
                  style: AppTextStyles.result),
              const SizedBox(height: 10),

              // Gráfico interactivo
              SizedBox(
                height: 250,
                child: InteractiveViewer(
                  maxScale: 5,
                  minScale: 0.5,
                  panEnabled: true,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                Text('M${value.toInt()}', style: const TextStyle(fontSize: 10)),
                            interval: 1,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: (payments.isNotEmpty ? payments.last / 4 : 10),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: payments.asMap().entries.map((e) {
                            return FlSpot((e.key + 1).toDouble(), e.value);
                          }).toList(),
                          isCurved: true,
                          color: Colors.white,
                          barWidth: 2,
                          dotData: FlDotData(show: false),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),


              // Lista de pagos sin contenedor
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final payment = payments[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMonth = index;
                      });
                    },
                    child: ListTile(
                      tileColor: selectedMonth == index
                          ? Colors.deepPurple.shade200
                          : Colors.transparent,
                      title: Text('Mes $month: \$${payment.toStringAsFixed(2)}'),
                      trailing: const Icon(Icons.payment),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



