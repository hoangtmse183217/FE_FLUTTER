// lib/core/widgets/app_button.dart
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nút sẽ bị vô hiệu hóa nếu isDisabled = true hoặc isLoading = true
    final bool isButtonDisabled = isDisabled || isLoading;

    return ElevatedButton(
      onPressed: isButtonDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // Thay đổi màu nền khi nút bị vô hiệu hóa
        backgroundColor: isButtonDisabled ? AppColors.border : AppColors.primary,
      ),
      child: isLoading
      // Hiển thị vòng xoay khi đang tải
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
      // Hiển thị nội dung bình thường
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }
}