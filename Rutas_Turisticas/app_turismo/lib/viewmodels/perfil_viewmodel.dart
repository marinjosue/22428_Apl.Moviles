import 'package:flutter/material.dart';
import '../services/user_service.dart';

class PerfilViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  Map<String, dynamic>? _perfil;
  Map<String, dynamic>? get perfil => _perfil;

  bool _cargando = false;
  bool get cargando => _cargando;

  Future<void> cargarPerfil(String uid) async {
    _cargando = true;
    notifyListeners();
    _perfil = await _userService.getPerfil(uid);
    _cargando = false;
    notifyListeners();
  }

  Future<void> actualizarPerfil(String uid, String name, String email, String photoUrl) async {
    _cargando = true;
    notifyListeners();
    await _userService.crearOActualizarPerfil(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
    await cargarPerfil(uid);
    _cargando = false;
    notifyListeners();
  }
}
