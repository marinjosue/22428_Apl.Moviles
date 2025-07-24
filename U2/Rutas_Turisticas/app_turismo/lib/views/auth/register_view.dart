import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _register() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final error = await authVM.register(
      _emailController.text.trim(),     // UID
      _nameController.text.trim(),      // Nombre
      _emailController.text.trim(),     // Email
      _passwordController.text.trim(),  // Contraseña
    );

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      setState(() => _errorMessage = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: _emailController,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
