import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';
import '../../validatories/validations.dart';
import '../views/styles.dart';

class AddDetallePage extends StatefulWidget {
  final int pedidoId;

  const AddDetallePage({Key? key, required this.pedidoId}) : super(key: key);

  @override
  _AddDetallePageState createState() => _AddDetallePageState();
}

class _AddDetallePageState extends State<AddDetallePage> {
  final _formKey = GlobalKey<FormState>();
  final _productoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _productoController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _agregarDetalle() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final provider = Provider.of<PedidoProvider>(context, listen: false);
        await provider.agregarDetalle(
          widget.pedidoId,
          _productoController.text.trim(),
          int.parse(_cantidadController.text),
          double.parse(_precioController.text),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Producto agregado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar el producto: $e'),
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
      // En vez de backgroundColor usamos un Container con el fondo degradado
      body: Container(
        decoration: AppStyles.gradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Agregar Producto',
                  style: AppStyles.headingText2(),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                automaticallyImplyLeading: true,
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
                                  'Infgesormación del Producto',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade900,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _productoController,
                                  decoration: AppStyles.textBoxDecoration(
                                      hintText: 'Nombre del Producto'),
                                  style: TextStyle(color: Colors.black87),
                                  validator: Validations.validarNombre,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _cantidadController,
                                  keyboardType: TextInputType.number,
                                  decoration: AppStyles.textBoxDecoration(
                                      hintText: 'Cantidad'),
                                  style: TextStyle(color: Colors.black87),
                                  validator: Validations.validarCantidad,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _precioController,
                                  keyboardType:
                                  TextInputType.numberWithOptions(decimal: true),
                                  decoration: AppStyles.textBoxDecoration(
                                      hintText: 'Precio Unitario'),
                                  style: TextStyle(color: Colors.black87),
                                  validator: Validations.validarPrecio,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _agregarDetalle,
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
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Agregando...'),
                            ],
                          )
                              : Text(
                            'Agregar Producto',
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

