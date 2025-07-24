import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/scan_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'utils/constants.dart';

void main() {
  testConnection();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ScanViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

import 'package:http/http.dart' as http;
void testConnection() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.0.100:8000/'));
    print('Status: [32m${response.statusCode}[0m');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: kRouteLogin,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      routes: {
        kRouteLogin: (_) => LoginScreen(),
        kRouteRegister: (_) => RegisterScreen(),
        kRouteScan: (_) => HomeScreen(),
      },
    );
  }
}
