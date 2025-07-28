import 'package:flutter/material.dart';

abstract class LoginViewModelInterface with ChangeNotifier {
  bool get isLoading;
  String? get error;
  bool get isLoggedIn;
  String? get currentUser;

  Future<bool> login(String usuario, String contrasena);

  // Métodos opcionales para testing
  @visibleForTesting
  void setMockCredentials(String user, String pass);

  @visibleForTesting
  void simulateError(String errorMessage);
}