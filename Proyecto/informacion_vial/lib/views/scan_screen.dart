import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scan_viewmodel.dart';
import '../models/traffic_sign.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ScanViewModel>(context);

    return Scaffold(
      body: Center(
        child: vm.isScanning
            ? CircularProgressIndicator()
            : vm.lastSign == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text("Escanear Señal"),
                        onPressed: () async => await vm.scanSignal(),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        vm.lastSign!.imageUrl,
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nombre de la señal:\n${vm.lastSign!.name}\nTipo de señal: ${vm.lastSign!.type}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text("¿Quieres saber multas por no respetarla?", style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => vm.lastSign = null,
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.blue),
                            onPressed: () async => await vm.scanSignal(),
                          ),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => Navigator.pushNamed(context, '/chat', arguments: vm.lastSign),
                          ),
                        ],
                      )
                    ],
                  ),
      ),
    );
  }
}
