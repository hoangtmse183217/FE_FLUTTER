import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart'; // Giả sử bạn có file này

class AppSnackbar {
  static void show(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      // NỘI DUNG: Row chứa Icon và Text
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
            size: 24,
          ),
          hSpaceM,
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      // GIAO DIỆN: Bo góc, đổ bóng và nổi
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      elevation: 6.0,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Hàm helper cho thông báo thành công
  static void showSuccess(BuildContext context, String message) {
    show(context, message);
  }

  // Hàm helper cho thông báo lỗi
  static void showError(BuildContext context, String message) {
    show(context, message, isError: true);
  }
}
