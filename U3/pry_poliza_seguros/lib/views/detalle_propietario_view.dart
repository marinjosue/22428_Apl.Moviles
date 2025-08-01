// detalle_propietario_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/detalle_propietario_viewmodel.dart';
import '../models/propietario_model.dart';

class DetallePropietarioView extends StatelessWidget {
  final Propietario propietario;

  const DetallePropietarioView({Key? key, required this.propietario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetallePropietarioViewModel()..cargarDetallePorUsuario(propietario.id),
      child: Scaffold(
        appBar: AppBar(title: Text('Detalle de ${propietario.nombreCompleto}')),
        body: Consumer<DetallePropietarioViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.error != null) {
              return Center(child: Text('Error: ${viewModel.error}'));
            } else if (viewModel.detalle == null) {
              return Center(child: Text('No se encontró información'));
            }

            final d = viewModel.detalle!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: ListTile(
                  title: Text('Modelo: ${d.modeloAuto}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Propietario: ${d.propietario}'),
                      Text('Edad: ${d.edadPropietario}'),
                      Text('Accidentes: ${d.accidentes}'),
                      Text('Valor Seguro: \$${d.valorSeguroAuto}'),
                      Text('Costo Total: \$${d.costoTotal}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
