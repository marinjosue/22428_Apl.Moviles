import 'package:flutter/material.dart';
import 'package:pry_poliza_seguros/viewmodels/login_viewmodel_interface.dart';

class FakeLoginViewModel extends LoginViewModelInterface {
  @override
  bool isLoading = false;

  @override
  String? error;

  @override
  bool isLoggedIn = false;

  @override
  String? currentUser;

  // Credenciales válidas para testing
  String mockUser = 'testuser';
  String mockPass = 'testpass';

  @override
  Future<bool> login(String usuario, String contrasena) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    if (usuario == mockUser && contrasena == mockPass) {
      isLoggedIn = true;
      currentUser = usuario;
      error = null;
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      error = 'Credenciales incorrectas';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void setMockCredentials(String user, String pass) {
    mockUser = user;
    mockPass = pass;
  }

  @override
  void simulateError(String errorMessage) {
    error = errorMessage;
    notifyListeners();
  }
}