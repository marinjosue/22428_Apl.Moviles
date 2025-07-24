import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../utils/constants.dart'; // Importa tus constantes

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

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
                  Text('INICIAR SESIÓN', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kPrimaryColor)), // Usa el color global
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: "Ingrese su Usuario"),
                    onChanged: (v) => vm.email = v,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: "Ingrese su contraseña"),
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
                        : Text("Ingresar"),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final ok = await vm.login();
                            if (ok) Navigator.pushReplacementNamed(context, kRouteScan); // Usa la constante de rutas
                          },
                  ),
                  TextButton(
                    child: Text('Registrarse'),
                    onPressed: () => Navigator.pushNamed(context, kRouteRegister), // Usa la constante de rutas
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
