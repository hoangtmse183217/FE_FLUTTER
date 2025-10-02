// lib/core/widgets/app_dialog.dart
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';

class AppDialog {
  // Hiển thị hộp thoại thông báo đơn giản
  static void showInfoDialog(BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Hiển thị hộp thoại xác nhận có/không
  static void showConfirmationDialog(BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = 'Xác nhận',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          AppButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            text: confirmText,
          ),
        ],
      ),
    );
  }
}