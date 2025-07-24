import 'package:flutter/material.dart';
import '../models/traffic_sign.dart';

class HistoryViewModel extends ChangeNotifier {
  final List<TrafficSign> history = [];

  void addToHistory(TrafficSign sign) {
    history.add(sign);
    notifyListeners();
  }
}
