import 'package:flutter/material.dart';

import 'views/registration_page.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {



      '/': (context) => RegistrationPage(),

    },
  ));
}
