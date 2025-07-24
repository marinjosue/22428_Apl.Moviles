import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  final VoidCallback? redirectAfterLogin;
  const LoginView({super.key, this.redirectAfterLogin});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _uidController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final error = await authVM.login(
      _uidController.text.trim(),
      _passwordController.text.trim(),
    );

    if (error == null) {
      if (widget.redirectAfterLogin != null) {
        widget.redirectAfterLogin!();
      }
      Navigator.pop(context); // O reemplaza por DrawerView si quieres
    } else {
      setState(() => _errorMessage = error);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _uidController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _login,
              icon: Icon(Icons.login, size: 20),
              label: Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: Colors.teal.withOpacity(0.5),
              ),
            ),
            TextButton(
              onPressed: _goToRegister,
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
