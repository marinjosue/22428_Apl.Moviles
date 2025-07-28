import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_poliza_seguros/viewmodels/propietario_viewmodel.dart';
import 'viewmodels/login_viewmodel_interface.dart';
import 'viewmodels/poliza_viewmodel_interfaz.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/poliza_viewmodel.dart';
import 'views/login_view.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModelInterface>(
          create: (_) => LoginViewModel(), // Implementación concreta
        ),
        ChangeNotifierProvider<PolizaViewModelInterface>(
          create: (_) => PolizaViewModel(), // Implementación concreta
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Pólizas',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginView(),
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}