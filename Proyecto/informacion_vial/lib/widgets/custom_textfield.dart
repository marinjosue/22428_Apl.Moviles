import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
