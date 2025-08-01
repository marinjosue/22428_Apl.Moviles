import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';
import 'login_viewmodel_interface.dart';

class LoginViewModel extends LoginViewModelInterface {
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  String? _currentUser;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  String? get currentUser => _currentUser;

  @override
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final loginData = Usuario(username: username, password: password);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:9090/bdd_dto/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData.toJson()),
      );

      if (response.statusCode == 200) {
        _isLoggedIn = true;
        _currentUser = username;
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        return false;
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Métodos para testing (no implementados en producción)
  @override
  void setMockCredentials(String user, String pass) {
    throw UnimplementedError('Solo disponible en versión fake');
  }

  @override
  void simulateError(String errorMessage) {
    throw UnimplementedError('Solo disponible en versión fake');
  }
}