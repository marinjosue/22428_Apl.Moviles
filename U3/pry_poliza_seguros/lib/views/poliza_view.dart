import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import '../viewmodels/poliza_viewmodel_interfaz.dart';

class PolizaView extends StatelessWidget {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();
  final _edadController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<PolizaViewModelInterface>(context);

    _valorController.text = vm.valorSeguroAuto.toString();
    _accidentesController.text = vm.accidentes.toString();
    _propietarioController.text = vm.propietario;
    _edadController.text = vm.edadPropietario.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Póliza", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput("Propietario", _propietarioController, (val) {
              vm.propietario = val;
              vm.notifyListeners();
            }, key: const ValueKey('propietarioInput')),
            SizedBox(height: 12),
            _buildInput("Valor del Seguro", _valorController, (val) {
              vm.valorSeguroAuto = double.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number, key: const ValueKey('valorSeguroInput')),
            SizedBox(height: 12),

            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleMedium),
            for (var m in ['A','B','C'])
              _buildRadio("Modelo $m", m, vm.modeloAuto, (val) {
                vm.modeloAuto = val!;
                vm.notifyListeners();
              }),

            SizedBox(height: 12),
            _buildInput("Edad propietario", _edadController, (val) {
              vm.edadPropietario = int.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number, key: const ValueKey('edadPropietarioInput')),

            SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, (val) {
              vm.accidentes = int.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number, key: const ValueKey('accidentesInput')),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const ValueKey('crearPolizaButton'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.teal,
                ),
                onPressed: vm.calcularPoliza,
                child: Text("CREAR PÓLIZA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Costo total: ${vm.costoTotal.toStringAsFixed(3)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, Function(String) onChanged, {TextInputType? keyboard, Key? key}) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged, {Key? key}) {
    return RadioListTile(
      key: key,
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.teal,
    );
  }
}