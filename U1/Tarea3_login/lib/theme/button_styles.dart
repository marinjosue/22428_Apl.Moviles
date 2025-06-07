import 'package:flutter/material.dart';

class AppButtonStyles {
  static final primary = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );

  static final secondary = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 220, 231, 233),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );

  static final outline = OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: const BorderSide(color: Colors.white),
  );
}
