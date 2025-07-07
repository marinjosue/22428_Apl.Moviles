import '../models/usuario.dart';
import '../services/firestore_service.dart';

class UsuarioRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Usuario?> obtenerUsuario(String userId) async {
    try {
      return await _firestoreService.getUsuario(userId);
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  Future<void> crearUsuario(Usuario usuario) async {
    try {
      await _firestoreService.createUsuario(usuario);
    } catch (e) {
      print('Error creando usuario: $e');
      rethrow;
    }
  }

  Future<void> actualizarFavoritos(String userId, List<String> favoritos) async {
    try {
      await _firestoreService.updateFavoritos(userId, favoritos);
    } catch (e) {
      print('Error actualizando favoritos: $e');
      rethrow;
    }
  }
}
