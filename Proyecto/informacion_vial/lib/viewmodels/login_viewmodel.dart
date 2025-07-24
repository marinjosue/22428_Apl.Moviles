import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;
  String? error;

  Future<bool> login() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await AuthService().login(email, password);
    isLoading = false;
    if (!result) {
      error = "Credenciales incorrectas";
    }
    notifyListeners();
    return result;
  }
}
