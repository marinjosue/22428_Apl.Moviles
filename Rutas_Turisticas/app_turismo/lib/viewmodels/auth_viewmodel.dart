import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  Usuario? _userData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Usuario? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        final perfil = await _userService.getPerfil(user.uid);
        if (perfil != null) {
          _userData = Usuario.fromMap(perfil, user.uid);
          _isAuthenticated = true;
        } else {
          _errorMessage = 'No se pudo obtener el perfil.';
        }
      } else {
        _errorMessage = 'Usuario o contraseña incorrectos.';
      }
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await _authService.createUserWithEmailAndPassword(email, password, name);
      if (user != null) {
        final perfil = await _userService.getPerfil(user.uid);
        if (perfil != null) {
          _userData = Usuario.fromMap(perfil, user.uid);
          _isAuthenticated = true;
        } else {
          _errorMessage = 'No se pudo crear el perfil.';
        }
      } else {
        _errorMessage = 'No se pudo crear el usuario.';
      }
    } catch (e) {
      _errorMessage = 'Error al crear cuenta: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInAnonymously() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await _authService.signInAnonymously();
      if (user != null) {
        final perfil = await _userService.getPerfil(user.uid);
        if (perfil != null) {
          _userData = Usuario.fromMap(perfil, user.uid);
          _isAuthenticated = true;
        } else {
          _errorMessage = 'No se pudo obtener el perfil.';
        }
      } else {
        _errorMessage = 'No se pudo iniciar sesión anónima.';
      }
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión anónima: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signOut();
      _userData = null;
      _isAuthenticated = false;
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      _errorMessage = 'Error al enviar email de recuperación: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> agregarFavorito(String sitioId) async {
    if (_userData == null) return;
    try {
      await _userService.agregarFavorito(_userData!.id, sitioId);
      final perfil = await _userService.getPerfil(_userData!.id);
      if (perfil != null) {
        _userData = Usuario.fromMap(perfil, _userData!.id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al agregar favorito: $e';
      notifyListeners();
    }
  }

  Future<void> eliminarFavorito(String sitioId) async {
    if (_userData == null) return;
    try {
      await _userService.eliminarFavorito(_userData!.id, sitioId);
      final perfil = await _userService.getPerfil(_userData!.id);
      if (perfil != null) {
        _userData = Usuario.fromMap(perfil, _userData!.id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar favorito: $e';
      notifyListeners();
    }
  }

  bool isFavorito(String sitioId) {
    return _userData?.sitiosFavoritos.contains(sitioId) ?? false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}