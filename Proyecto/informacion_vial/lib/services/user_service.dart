import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/login_response.dart';
import 'backend_service.dart';

class UserService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _accessTokenKey = 'access_token';
  
  static UserService? _instance;
  User? _currentUser;
  String? _accessToken;
  
  UserService._();
  
  static UserService get instance {
    _instance ??= UserService._();
    return _instance!;
  }
  
  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoggedIn => _currentUser != null && _accessToken != null;
  
  Future<void> saveUserAndToken(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id!);
    await prefs.setString(_userNameKey, user.name);
    await prefs.setString(_userEmailKey, user.email);
    await prefs.setString(_accessTokenKey, token);
    _currentUser = user;
    _accessToken = token;
  }
  
  Future<void> saveLoginResponse(LoginResponse loginResponse) async {
    try {
      print('Obteniendo información del usuario con token...');
      // Obtener información del usuario usando el token desde el endpoint /me
      final user = await BackendService().getUserInfo(loginResponse.accessToken);
      await saveUserAndToken(user, loginResponse.accessToken);
      print('Usuario guardado exitosamente: ${user.name}');
    } catch (e) {
      print('Error obteniendo información del usuario: $e');
      throw Exception('Error obteniendo información del usuario: $e');
    }
  }
  
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    final name = prefs.getString(_userNameKey);
    final email = prefs.getString(_userEmailKey);
    final token = prefs.getString(_accessTokenKey);
    
    if (id != null && name != null && email != null && token != null) {
      _currentUser = User(id: id, name: name, email: email);
      _accessToken = token;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
  }
}
