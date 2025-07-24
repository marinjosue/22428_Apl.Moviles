import 'package:flutter/material.dart';
import '../bottomnav/sitios_view.dart';
import '../gastronomia/gastronomia_view.dart';
import '../transporte/transporte_view.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SitiosView(),
    GastronomiaView(),
    TransporteView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Sitios turísticos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Gastronomía',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Transporte',
          ),
        ],
      ),
    );
  }
}
