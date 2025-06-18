import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';
import '../../validatories/validations.dart';
import '../views/styles.dart'; // donde está tu AppStyles

class CreatePedidoPage extends StatefulWidget {
  @override
  _CreatePedidoPageState createState() => _CreatePedidoPageState();
}

class _CreatePedidoPageState extends State<CreatePedidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _clienteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _crearPedido() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final provider = Provider.of<PedidoProvider>(context, listen: false);
        await provider.crearPedido(
          _clienteController.text.trim(),
          _selectedDate.toIso8601String().split('T')[0],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pedido creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.gradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text('Nuevo Pedido', style: AppStyles.headingText()),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información del Pedido',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade900,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _clienteController,
                                  decoration: AppStyles.textBoxDecoration(
                                      hintText: 'Nombre del Cliente'),
                                  style: TextStyle(color: Colors.indigo.shade900),
                                  validator: Validations.validarNombre,
                                ),
                                SizedBox(height: 16),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[400]!),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: Colors.grey[600]),
                                        SizedBox(width: 12),
                                        Text(
                                          'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_drop_down,
                                            color: Colors.grey[600]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _crearPedido,
                          style: AppStyles.primaryButton(),
                          child: _isLoading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Creando...'),
                            ],
                          )
                              : Text(
                            'Crear Pedido',
                            style: AppStyles.buttonText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
