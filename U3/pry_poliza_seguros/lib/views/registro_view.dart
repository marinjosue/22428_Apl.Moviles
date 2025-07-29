import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registro_viewmodel.dart';

class RegistroView extends StatelessWidget {
  const RegistroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistroViewModel(),
      child: _RegistroForm(),
    );
  }
}

class _RegistroForm extends StatefulWidget {
  @override
  State<_RegistroForm> createState() => _RegistroFormState();
}

class _RegistroFormState extends State<_RegistroForm> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistroViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                final success = await viewModel.registrar(
                  _userController.text.trim(),
                  _passController.text.trim(),
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.mensaje!)),
                  );
                  Navigator.pop(context); // volver al login
                }
              },
              child: viewModel.isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Registrarse', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            if (viewModel.mensaje != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  viewModel.mensaje!,
                  style: TextStyle(
                    color: viewModel.mensaje == 'Registro exitoso' ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
