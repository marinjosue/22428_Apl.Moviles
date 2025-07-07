import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  Stream<User?> get userChanges => _auth.userChanges();

  Future<User?> signInAnonymously() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      
      if (user != null) {
        // Crear o actualizar perfil en MongoDB
        await _userService.crearOActualizarPerfil(
          uid: user.uid,
          name: 'Usuario Anónimo',
          email: user.email ?? 'anonimo@app.com',
          photoUrl: user.photoURL ?? '',
        );
      }
      
      return user;
    } catch (e) {
      print('Error en signInAnonymously: $e');
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      
      if (user != null) {
        // Actualizar perfil en MongoDB
        await _userService.crearOActualizarPerfil(
          uid: user.uid,
          name: user.displayName ?? 'Usuario',
          email: user.email ?? email,
          photoUrl: user.photoURL ?? '',
        );
      }
      
      return user;
    } catch (e) {
      print('Error en signInWithEmailAndPassword: $e');
      rethrow;
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      
      if (user != null) {
        // Actualizar el display name
        await user.updateDisplayName(name);
        
        // Crear perfil en MongoDB
        await _userService.crearOActualizarPerfil(
          uid: user.uid,
          name: name,
          email: email,
          photoUrl: user.photoURL ?? '',
        );
      }
      
      return user;
    } catch (e) {
      print('Error en createUserWithEmailAndPassword: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error en signOut: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error en sendPasswordResetEmail: $e');
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;
}
