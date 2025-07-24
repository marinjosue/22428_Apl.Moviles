import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plataforma Flutter',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: Platform.isAndroid ? AndroidHomePage() : IOSHomePage(),
    );
  }
}

// Página para Android
class AndroidHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interfaz Android', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.android, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'Bienvenido a Android',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.touch_app, color: Colors.white),
                    label: Text('Botón Android',
                      style: TextStyle(color: Colors.white)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:EdgeInsets.symmetric(horizontal: 24,vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Página para iOS
class IOSHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Interfaz iOS'),
        backgroundColor: CupertinoColors.systemGrey5,
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: CupertinoColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.device_phone_portrait, size: 80,
                      color: CupertinoColors.activeBlue),
                  SizedBox(height: 16),
                  Text(
                    'Bienvenido a iOS',
                    style:
                    CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.hand_point_right_fill),
                        SizedBox(width: 8),
                        Text('Botón iOS'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
