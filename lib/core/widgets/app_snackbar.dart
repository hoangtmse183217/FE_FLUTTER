// lib/core/widgets/app_snackbar.dart
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class AppSnackbar {
  static void _showSnackbar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.green.shade700);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.primary);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.blueGrey.shade700);
  }
}