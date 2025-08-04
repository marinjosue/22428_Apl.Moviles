import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../services/user_service.dart';

class HistoryViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> history = [];
  bool isLoading = false;
  String? error;

  Future<void> loadHistory() async {
    final user = UserService.instance.currentUser;
    if (user == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      history = await BackendService().getHistory(user.id!);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }
}
