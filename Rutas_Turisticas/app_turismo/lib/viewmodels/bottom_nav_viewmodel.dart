import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get selectedIndex => _currentIndex;

  void changeIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      notifyListeners(); // Notifica a los widgets que escuchan este modelo que el estado ha cambiado.
    }
  }
}