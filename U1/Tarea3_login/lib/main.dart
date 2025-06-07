import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/registration_page.dart';
import 'views/welcome_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/register': (context) => RegistrationPage(),
      '/welcome': (context) => WelcomePage(),
    },
  ));
}
