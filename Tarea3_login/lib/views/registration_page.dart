import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import '../theme/button_styles.dart';
import '../theme/color_schemes.dart';
import '../controller/registration_controller.dart';
import '../model/login_model.dart';
import '../validators/form_validators.dart';


class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final registrationController = RegistrationController();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final postalCodeController = TextEditingController();
  String? provinceName;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorSchemes.primary,
        title: const Text('Registro', style: AppTextStyles.title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColorSchemes.primary, AppColorSchemes.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Icon(Icons.person, size: 100, color: Colors.white),
              const SizedBox(height: 20),

              _buildField('Usuario', usernameController, icon: Icons.person,  validator: FormValidators.validateUsername),
              _buildField('Contraseña', passwordController, icon: Icons.lock, obscure: true,  validator: FormValidators.validatePassword),
              _buildField('Nombres', firstNameController, icon: Icons.badge,  validator: FormValidators.validateText),
              _buildField('Apellidos', lastNameController, icon: Icons.badge_outlined,  validator: FormValidators.validateText),
              _buildField('Dirección', addressController, icon: Icons.location_on, validator: FormValidators.validateText),
              _buildField('Ciudad', cityController, icon: Icons.location_city, validator: FormValidators.validateText),
              _buildField('Email', emailController, icon: Icons.email, validator: FormValidators.validateEmail),
              _buildField('Teléfono', phoneController, icon: Icons.phone, validator: FormValidators.validatePhone),
              _buildField('Código Postal', postalCodeController, icon: Icons.markunread_mailbox,  validator: FormValidators.validatePostalCode),
              ElevatedButton.icon(
                style: AppButtonStyles.primary,
                onPressed: () {
                  final code = postalCodeController.text;
                  final result = FormValidators.getProvinceByPostalCode(code);
                  setState(() {
                    provinceName = result;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result != null
                            ? 'Código válido. Pertenece a: $result'
                            : 'Código postal inválido en Ecuador',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Validar Código Postal', style: AppTextStyles.button),
              ),
              if (provinceName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Provincia: $provinceName',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newUser = UsuarioModel(
                      username: usernameController.text,
                      password: passwordController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      address: addressController.text,
                      city: cityController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      postalCode: postalCodeController.text,
                    );
                    await registrationController.saveUser(newUser);
                    Navigator.pushNamed(context, '/', arguments: newUser.username);
                  }
                },
                child: const Text('Registrar', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        bool obscure = false,
        IconData? icon,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: AppTextStyles.input,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: AppTextStyles.input,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Requerido' : null,
      ),
    );
  }
}
