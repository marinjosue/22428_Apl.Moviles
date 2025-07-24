import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle valueText() {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87,
    );
  }

  static TextStyle labelText() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey[700],
      fontSize: 14,
    );
  }
  static TextStyle sectionTitle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blue[800], // Cambia al color que uses en tu tema principal
    );
  }
  // Gradient background decoration with 2 colors
  static BoxDecoration gradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.indigo.shade700 , Colors.blue.shade300],
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
      ),
    );
  }

  // Text styles
  static TextStyle headingText() {
    return TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,  // Esto pone la letra en cursiva
    );
  }
  static TextStyle headingText2() {
    return TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,  // Esto pone la letra en cursiva
    );
  }



  static TextStyle bodyText() {
    return TextStyle(
      color: Colors.white70,
      fontSize: 16,
    );
  }

  static TextStyle buttonText() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  // Button styles
  static ButtonStyle primaryButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo, // button background color
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: buttonText(),
    );
  }

  static ButtonStyle secondaryButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: buttonText(),
    );
  }

  // TextField decoration style
  static InputDecoration textBoxDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[1000],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),

      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.red),
      ),
    );


  }
}
