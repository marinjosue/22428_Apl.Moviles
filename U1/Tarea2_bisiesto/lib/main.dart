import 'package:flutter/material.dart';
import 'views/result.dart';
import 'views/verify.dart';
import './themes/app_themes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Año Bisiesto',
    initialRoute: '/',
    routes: {
      '/':(context)=>Verify(),
      '/result':(context)=>Result(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: AppThemes.appBarTheme,
      cardTheme: AppThemes.cardTheme,
      inputDecorationTheme: AppThemes.inputDecorationTheme,
    ),
  ));
}