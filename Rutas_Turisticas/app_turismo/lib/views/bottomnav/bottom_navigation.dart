import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/bottom_nav_viewmodel.dart';
import 'sitios_view.dart';
import '../gastronomia/gastronomia_view.dart';
import '../transporte/transporte_view.dart';


class BottomNavigation extends StatelessWidget {
  final List<Widget> _screens = [
    SitiosView(),
    GastronomiaView(),
    TransporteView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: _screens[viewModel.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.selectedIndex,
            selectedItemColor: Colors.red[800],
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            onTap: (int index) => viewModel.changeIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Sitios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_outlined),
                label: 'Gastronomía',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus_outlined),
                label: 'Transporte',
              ),
            ],
          ),
        );
      },
    );
  }
}
