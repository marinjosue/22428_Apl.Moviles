import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/login_viewmodel_interface.dart';
import 'home_screen.dart';
import 'registro_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _LoginForm();
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModelInterface>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: const ValueKey('usuarioTextField'),
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              key: const ValueKey('passwordTextField'),
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const ValueKey('loginButton'),
              onPressed: viewModel.isLoading ? null : () async {
                final success = await viewModel.login(
                  _userController.text.trim(),
                  _passController.text.trim(),
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: viewModel.isLoading ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Ingresar', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.teal,
              ),
            ),
            TextButton(
              key: const ValueKey('registroLinkButton'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistroView()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate aquí'),
            ),
            if (viewModel.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  viewModel.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
