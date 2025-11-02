import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool isSmall; // THÊM THAM SỐ MỚI

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isSmall = false, // Gán giá trị mặc định
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = isDisabled || isLoading;
    // SỬA LỖI: Điều chỉnh padding dựa trên isSmall
    final buttonPadding = isSmall
        ? const EdgeInsets.symmetric(vertical: 10, horizontal: 16)
        : const EdgeInsets.symmetric(vertical: 16, horizontal: 24);

    final buttonTextStyle = isSmall
        ? const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
        : const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    return ElevatedButton(
      onPressed: isButtonDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isButtonDisabled ? AppColors.border : AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: buttonPadding, // Sử dụng padding đã điều chỉnh
        textStyle: buttonTextStyle, // Sử dụng text style đã điều chỉnh
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: isSmall ? 18 : 20),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(text, textAlign: TextAlign.center)),
              ],
            ),
    );
  }
}
