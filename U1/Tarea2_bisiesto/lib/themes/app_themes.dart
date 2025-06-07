import 'package:flutter/material.dart';
import 'color_schemes.dart';
import './text_styles.dart';

class AppThemes {
  // AppBar
  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.primary,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.cardBackground,
      fontSize: 20,
    ),
    iconTheme: IconThemeData(
      color: AppColors.cardBackground,
    ),
  );

  // Card
  static final CardTheme cardTheme = CardTheme(
    color: AppColors.cardBackground,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: EdgeInsets.symmetric(vertical: 8),
  );

  // SnackBar
  static SnackBar snackBar(String message, {Color? backgroundColor}) {
    return SnackBar(
      content: Text(message, style: AppTextStyles.bodyText),
      backgroundColor: backgroundColor ?? AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // TextField
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.textSecondary),
  );
}

