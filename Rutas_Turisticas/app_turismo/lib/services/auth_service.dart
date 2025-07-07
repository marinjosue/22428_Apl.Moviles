import '../services/user_service.dart';
import '../models/usuario.dart';

class AuthService {
  final UserService _userService = UserService();

  Future<Usuario> loginWithEmailAndPassword(String email, String password) async {
    return await _userService.loginUsuario(email, password);
  }

  Future<Usuario> registerWithEmailAndPassword(String email, String password, String nombre) async {
    return await _userService.registrarUsuario(email, password, nombre);
  }
}
