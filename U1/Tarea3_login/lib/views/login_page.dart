import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../theme/text_styles.dart';
import '../theme/button_styles.dart';
import '../theme/color_schemes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Definir estado del formulario
  final _formKey = GlobalKey<FormState>();
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();

  final controller = LoginController();

  bool recordarCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Login', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColorSchemes.primary, AppColorSchemes.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usuarioController,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      hintText: 'USERNAME',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: controller.vaidarUsuario,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: claveController,
                    style: AppTextStyles.input,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      hintText: 'PASSWORD',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: controller.vaidarClave,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: recordarCheck,
                        onChanged: (value) {
                          setState(() {
                            recordarCheck = value!;
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                      ),
                      const Text(
                        'Recordar usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: AppButtonStyles.primary,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.login(
                          context,
                          usuarioController.text,
                          claveController.text,
                        );
                      }
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: AppTextStyles.button,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: AppButtonStyles.secondary,
                    child: const Text(
                      'Registrarse',
                      style: AppTextStyles.button,
                    ),
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
