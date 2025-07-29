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
    return const _LoginForm();
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> with TickerProviderStateMixin {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Animación principal
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animación de pulso para el logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModelInterface>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C851), // Verde principal
              Color(0xFF007E33), // Verde oscuro
              Color(0xFF00BF63), // Verde medio
              Color(0xFF00A651), // Verde vibrante
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.8, -0.6),
              radius: 1.5,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo animado con efecto glassmorphism mejorado
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.4),
                                        Colors.white.withOpacity(0.1),
                                        Colors.green.withOpacity(0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 25,
                                        offset: const Offset(0, 12),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(-5, -5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 35),

                          // Título con efecto mejorado
                          const Text(
                            'Poliza',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),


                          // Card de login con nuevo diseño
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.85),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                              child: Column(
                                children: [
                                  // Campo de usuario mejorado
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF8F9FA),
                                      border: Border.all(
                                        color: const Color(0xFF00C851).withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00C851).withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      key: const ValueKey('usuarioTextField'),
                                      controller: _userController,
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Usuario',
                                        labelStyle: TextStyle(
                                          color: const Color(0xFF00C851).withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person_outline_rounded,
                                          color: const Color(0xFF00C851).withOpacity(0.8),
                                          size: 24,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // Campo de contraseña mejorado
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF8F9FA),
                                      border: Border.all(
                                        color: const Color(0xFF00C851).withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00C851).withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      key: const ValueKey('passwordTextField'),
                                      controller: _passController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        labelStyle: TextStyle(
                                          color: const Color(0xFF00C851).withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: const Color(0xFF00C851).withOpacity(0.8),
                                          size: 24,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: const Color(0xFF00C851).withOpacity(0.8),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Botón de login con nuevo diseño
                                  Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF00C851),
                                          Color(0xFF00BF63),
                                          Color(0xFF00A651),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00C851).withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      key: const ValueKey('loginButton'),
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () async {
                                        final success = await viewModel.login(
                                          _userController.text.trim(),
                                          _passController.text.trim(),
                                        );
                                        if (success) {
                                          Navigator.pushReplacementNamed(context, '/home');
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
                                        width: 26,
                                        height: 26,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                          : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.login_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Mensaje de error mejorado
                                  if (viewModel.error != null) ...[
                                    const SizedBox(height: 25),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: Colors.red.shade600,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              viewModel.error!,
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),

                          // Enlace de registro mejorado
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: TextButton(
                              key: const ValueKey('registroLinkButton'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegistroView()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                  vertical: 18,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_add_rounded,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '¿No tienes cuenta? Regístrate',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}