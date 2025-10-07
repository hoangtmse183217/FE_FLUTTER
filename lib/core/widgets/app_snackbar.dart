import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';

// Enum để định nghĩa các loại SnackBar
enum SnackBarType { success, error, info }

class AppSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
      }) {
    // Ẩn SnackBar hiện tại nếu có
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Lấy màu sắc và icon dựa trên loại SnackBar
    Color backgroundColor;
    IconData iconData;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.success; // Sử dụng màu từ AppColors
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.error; // Sử dụng màu từ AppColors
        iconData = Icons.highlight_off;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = Colors.blueGrey.shade700;
        iconData = Icons.info_outline;
        break;
    }

    // Tạo SnackBar với thiết kế mới
    final snackBar = SnackBar(
      // Nội dung tùy chỉnh với Row
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          hSpaceM,
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating, // Quan trọng để có thể tùy chỉnh margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: kSpacingM,
        horizontal: kSpacingM,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: kSpacingM,
      ),
      duration: const Duration(seconds: 3),
    );

    // Hiển thị SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // --- Các hàm helper để gọi dễ dàng hơn ---

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: SnackBarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: SnackBarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: SnackBarType.info);
  }
}