import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/usuario.dart';

class PerfilViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _cargando = false;
  bool get cargando => _cargando;

  Future<void> cargarPerfil(String id) async {
    _cargando = true;
    notifyListeners();
    try {
      _usuario = await _userService.getPerfilUsuario(id);
    } catch (e) {
      _usuario = null;
    }
    _cargando = false;
    notifyListeners();
  }

  Future<void> actualizarPerfil(String id, String nombre, String email) async {
    _cargando = true;
    notifyListeners();
    try {
      await _userService.actualizarPerfilUsuario(id, nombre, email);
      await cargarPerfil(id);
    } catch (e) {}
    _cargando = false;
    notifyListeners();
  }
}
