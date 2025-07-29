import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _RegistroFormState extends State<_RegistroForm> with TickerProviderStateMixin {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _resultController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultController.dispose();
    _userController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistroViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Header con icono
                  _buildHeader(),
                  const SizedBox(height: 40),

                  // Información del usuario
                  _buildSection(
                    title: 'Información de la Cuenta',
                    icon: Icons.person_add_rounded,
                    children: [
                      _buildInput(
                        "Nombre de usuario",
                        _userController,
                        Icons.person_outline_rounded,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese un nombre de usuario';
                          }
                          if (value!.length < 3) {
                            return 'El nombre debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "Correo electrónico",
                        _emailController,
                        Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese un correo electrónico';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                            return 'Ingrese un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Información de seguridad
                  _buildSection(
                    title: 'Seguridad',
                    icon: Icons.security_rounded,
                    children: [
                      _buildPasswordInput(
                        "Contraseña",
                        _passController,
                        _obscurePassword,
                            () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese una contraseña';
                          }
                          if (value!.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordInput(
                        "Confirmar contraseña",
                        _confirmPassController,
                        _obscureConfirmPassword,
                            () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor confirme su contraseña';
                          }
                          if (value != _passController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  // Botón de registro
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF673AB7),
                          Color(0xFF9C27B0),
                          Color(0xFF673AB7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF673AB7).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await viewModel.registrar(
                            _userController.text.trim(),
                            _passController.text.trim(),
                          );

                          if (success) {
                            _resultController.forward();
                            HapticFeedback.lightImpact();

                            // Mostrar resultado y navegar después de un delay
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          } else {
                            HapticFeedback.mediumImpact();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'CREAR CUENTA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Resultado
                  if (viewModel.mensaje != null)
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildResultCard(
                        viewModel.mensaje!,
                        viewModel.mensaje == 'Registro exitoso',
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Enlace al login
                  _buildLoginLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF673AB7),
            Color(0xFF9C27B0),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF673AB7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Complete los datos para registrarse',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF673AB7).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF673AB7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType? keyboard,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3E50),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF673AB7).withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF673AB7).withOpacity(0.7),
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF673AB7).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF673AB7).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF673AB7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
      String label,
      TextEditingController controller,
      bool obscureText,
      VoidCallback onToggle, {
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3E50),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF673AB7).withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: const Color(0xFF673AB7).withOpacity(0.7),
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF673AB7).withOpacity(0.7),
            size: 22,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF673AB7).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF673AB7).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF673AB7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildResultCard(String mensaje, bool isSuccess) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSuccess
              ? [
            const Color(0xFF4CAF50),
            const Color(0xFF66BB6A),
          ]
              : [
            const Color(0xFFF44336),
            const Color(0xFFE57373),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFF44336))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 15),
          Text(
            isSuccess ? '¡Registro Exitoso!' : 'Error en el Registro',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: RichText(
          text: const TextSpan(
            text: '¿Ya tienes una cuenta? ',
            style: TextStyle(
              color: Color(0xFF7B8794),
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: 'Inicia sesión',
                style: TextStyle(
                  color: Color(0xFF673AB7),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}