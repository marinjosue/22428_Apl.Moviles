import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';
import '../utils/constants.dart';
import '../utils/dialogs.dart'; // Importa dialogs
import '../utils/validators.dart'; // Importa validadores

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('REGÍSTRATE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: "Ingrese un correo electrónico"),
                    onChanged: (v) => vm.email = v,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: "Ingrese un nombre"),
                    onChanged: (v) => vm.name = v,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: "Ingrese una contraseña"),
                    obscureText: true,
                    onChanged: (v) => vm.password = v,
                  ),
                  SizedBox(height: 20),
                  if (vm.error != null)
                    Text(vm.error!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                    child: vm.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Registrarse !!"),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            // Validación usando validators.dart
                            if (!isValidEmail(vm.email)) {
                              showErrorDialog(context, "Correo electrónico no válido");
                              return;
                            }
                            if (!isValidPassword(vm.password)) {
                              showErrorDialog(context, "La contraseña debe tener al menos 6 caracteres");
                              return;
                            }
                            final ok = await vm.register();
                            if (ok) Navigator.pushReplacementNamed(context, kRouteLogin);
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
