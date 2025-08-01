import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_poliza_seguros/viewmodels/login_viewmodel_interface.dart';
import 'package:pry_poliza_seguros/viewmodels/poliza_viewmodel_interfaz.dart';
import 'package:pry_poliza_seguros/views/home_screen.dart';
import 'package:pry_poliza_seguros/views/login_view.dart';

class TestApp extends StatelessWidget {
  final LoginViewModelInterface loginVM;
  final PolizaViewModelInterface polizaVM;
  final bool isLoggedIn;

  const TestApp({
    required this.loginVM,
    required this.polizaVM,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModelInterface>.value(value: loginVM),
        ChangeNotifierProvider<PolizaViewModelInterface>.value(value: polizaVM),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const HomeScreen() : const LoginView(),
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}