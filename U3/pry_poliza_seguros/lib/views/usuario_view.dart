import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/propietario_viewmodel.dart';
import 'detalle_propietario_view.dart';

class UsuarioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PropietarioViewModel()..cargarPropietarios(),
      child: Scaffold(
        appBar: AppBar(title: Text('Lista de Propietarios')),
        body: Consumer<PropietarioViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.error != null) {
              return Center(child: Text('Error: ${viewModel.error}'));
            } else if (viewModel.propietarios.isEmpty) {
              return Center(child: Text('No hay propietarios'));
            }

            return ListView.builder(
              itemCount: viewModel.propietarios.length,
              itemBuilder: (context, index) {
                final p = viewModel.propietarios[index];
                return ListTile(
                  title: Text(p.nombreCompleto),
                  subtitle: Text('Edad: ${p.edad} - Automóviles: ${p.automovilIds.join(", ")}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetallePropietarioView(propietario: p),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}