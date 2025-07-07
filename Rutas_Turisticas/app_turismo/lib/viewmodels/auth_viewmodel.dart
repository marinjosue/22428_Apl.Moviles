import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _usuario;
  bool get isAuthenticated => _usuario != null;
  Map<String, dynamic>? get usuario => _usuario;

  Future<String?> login(String uid, String password) async {
    final result = await _authService.login(uid, password);
    if (result['success']) {
      _usuario = result['user'];
      notifyListeners();
      return null; // sin error
    } else {
      return result['message'];
    }
  }

  Future<String?> register(String uid, String name, String email, String password, [String photoUrl = '']) async {
    final result = await _authService.register(uid, name, email, password, photoUrl);
    if (result['success']) {
      return null;
    } else {
      return result['message'];
    }
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}