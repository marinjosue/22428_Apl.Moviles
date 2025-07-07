import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/user_service.dart';

class AuthViewModel with ChangeNotifier {
  Usuario? _usuario;
  bool get isAuthenticated => _usuario != null;
  Usuario? get usuario => _usuario;

  final UserService _userService = UserService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> registerWithBackend({
    required String email,
    required String password,
    required String nombre,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final usuario = await _userService.registrarUsuario(email, password, nombre);
      _usuario = usuario;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loginWithBackend({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final usuario = await _userService.loginUsuario(email, password);
      _usuario = usuario;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loginAsGuest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _usuario = Usuario(
        id: 'guest',
        email: '',
        nombre: 'Invitado',
        sitiosFavoritos: [],
        fechaRegistro: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void signOut() {
    _usuario = null;
    notifyListeners();
  }
}
