import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';
import '../models/traffic_sign.dart';
import '../utils/constants.dart';
import '../utils/date_format.dart'; // Importa el formateador

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HistoryViewModel>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: vm.history.length,
        itemBuilder: (context, idx) {
          final sign = vm.history[idx];
          return ListTile(
            leading: Image.asset(sign.imageUrl, height: 48, width: 48),
            title: Text(sign.name),
            subtitle: Text('${sign.type} - ${formatDate(DateTime.now())}'),
            onTap: () {
              // Acción al seleccionar historial
            },
          );
        },
      ),
    );
  }
}
