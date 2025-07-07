import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Comentamos Firebase temporalmente hasta configurarlo
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'viewmodels/sitios_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/perfil_viewmodel.dart';
import 'viewmodels/bottom_nav_viewmodel.dart';
import 'viewmodels/comentario_viewmodel.dart';
import 'views/drawer/drawer_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Comentamos Firebase temporalmente
    // await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Error initializing app: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SitiosViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PerfilViewModel()),
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
        ChangeNotifierProvider(create: (_) => ComentarioViewModel()),
      ],
      child: MaterialApp(
        title: 'Guía Turística',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DrawerView(), // Directo sin FutureBuilder
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ErrorScreen(error: error),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error de Inicialización',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Ocurrió un error al inicializar la aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Cerrar App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
               