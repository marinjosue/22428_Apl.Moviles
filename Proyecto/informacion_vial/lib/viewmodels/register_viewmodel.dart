import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  String email = '';
  String name = '';
  String password = '';
  bool isLoading = false;
  String? error;

  Future<bool> register() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await AuthService().register(email, name, password);
    isLoading = false;
    if (!result) {
      error = "Error en el registro";
    }
    notifyListeners();
    return result;
  }
}
