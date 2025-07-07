import 'package:flutter/material.dart';
// Comentamos Firebase temporalmente
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import '../services/user_service.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  // Versión simplificada sin Firebase para testing
  Usuario? _userData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  Usuario? get userData => _userData;
  // User? get firebaseUser => null; // Temporalmente null
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel() {
    // Simulamos un usuario logueado automáticamente para testing
    _simulateAutoLogin();
  }

  void _simulateAutoLogin() {
    Future.delayed(Duration(seconds: 1), () {
      _userData = Usuario(
        id: 'test_user_123',
        email: 'usuario@test.com',
        nombre: 'Usuario de Prueba',
        sitiosFavoritos: [],
        fechaRegistro: DateTime.now(),
      );
      _isAuthenticated = true;
      notifyListeners();
    });
  }

  Future<void> signInAnonymously() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(Duration(seconds: 1)); // Simular carga
      
      _userData = Usuario(
        id: 'anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'anonimo@app.com',
        nombre: 'Usuario Anónimo',
        sitiosFavoritos: [],
        fechaRegistro: DateTime.now(),
      );
      _isAuthenticated = true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión: $e';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(Duration(seconds: 1)); // Simular carga
      
      _userData = Usuario(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        nombre: 'Usuario',
        sitiosFavoritos: [],
        fechaRegistro: DateTime.now(),
      );
      _isAuthenticated = true;
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
      await Future.delayed(Duration(seconds: 1)); // Simular carga
      
      _userData = Usuario(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        nombre: name,
        sitiosFavoritos: [],
        fechaRegistro: DateTime.now(),
      );
      _isAuthenticated = true;
    } catch (e) {
      _errorMessage = 'Error al crear cuenta: $e';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.delayed(Duration(milliseconds: 500)); // Simular carga
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
      await Future.delayed(Duration(seconds: 1)); // Simular envío
      // Simular éxito
    } catch (e) {
      _errorMessage = 'Error al enviar email de recuperación: $e';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> agregarFavorito(String sitioId) async {
    if (_userData == null) return;
    
    try {
      final favoritosActualizados = List<String>.from(_userData!.sitiosFavoritos);
      if (!favoritosActualizados.contains(sitioId)) {
        favoritosActualizados.add(sitioId);
        _userData = Usuario(
          id: _userData!.id,
          email: _userData!.email,
          nombre: _userData!.nombre,
          sitiosFavoritos: favoritosActualizados,
          fechaRegistro: _userData!.fechaRegistro,
        );
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
      final favoritosActualizados = List<String>.from(_userData!.sitiosFavoritos);
      favoritosActualizados.remove(sitioId);
      _userData = Usuario(
        id: _userData!.id,
        email: _userData!.email,
        nombre: _userData!.nombre,
        sitiosFavoritos: favoritosActualizados,
        fechaRegistro: _userData!.fechaRegistro,
      );
      notifyListeners();
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
