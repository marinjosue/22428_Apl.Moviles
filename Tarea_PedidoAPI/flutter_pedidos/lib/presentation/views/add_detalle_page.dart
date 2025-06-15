import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';

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
        
        // Return true to indicate success
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Agregar Producto'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información del Producto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      TextFormField(
                        controller: _productoController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Producto',
                          prefixIcon: Icon(Icons.shopping_basket),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingrese el nombre del producto';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _cantidadController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingrese la cantidad';
                          }
                          final cantidad = int.tryParse(value);
                          if (cantidad == null || cantidad <= 0) {
                            return 'Ingrese una cantidad válida mayor a 0';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _precioController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Precio Unitario',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingrese el precio';
                          }
                          final precio = double.tryParse(value);
                          if (precio == null || precio <= 0) {
                            return 'Ingrese un precio válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _agregarDetalle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Agregando...'),
                        ],
                      )
                    : Text(
                        'Agregar Producto',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
