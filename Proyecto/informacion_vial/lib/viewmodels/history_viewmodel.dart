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

  // Eliminar un historial específico
  Future<bool> deleteHistory(int historyId) async {
    try {
      final success = await BackendService().deleteHistory(historyId);
      if (success) {
        // Remover del array local
        history.removeWhere((item) => item['id'] == historyId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error eliminando historial: $e');
      return false;
    }
  }

  // Eliminar todos los historiales del usuario actual
  Future<bool> deleteAllHistory() async {
    final user = UserService.instance.currentUser;
    if (user == null) return false;

    try {
      final success = await BackendService().deleteAllHistory(user.id!);
      if (success) {
        // Limpiar array local
        history.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error eliminando todos los historiales: $e');
      return false;
    }
  }

  // Refrescar historial después de eliminar
  Future<void> refreshHistory() async {
    await loadHistory();
  }
}
