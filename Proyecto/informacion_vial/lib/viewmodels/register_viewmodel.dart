import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../services/user_service.dart';

class RegisterViewModel extends ChangeNotifier {
  String email = '';
  String name = '';
  String password = '';
  bool isLoading = false;
  String? error;

  Future<bool> register() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await BackendService().register(name, email, password);
      // Después del registro, hacer login automáticamente
      final loginResponse = await BackendService().login(email, password);
      await UserService.instance.saveLoginResponse(loginResponse);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
