import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';

/// A reusable widget for displaying a generic error message with a retry button.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isMini; // THÊM MỚI: Tham số để hiển thị phiên bản nhỏ gọn

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.isMini = false, // THÊM MỚI: Giá trị mặc định là false
  });

  @override
  Widget build(BuildContext context) {
    // SỬA ĐỔI: Sử dụng isMini để điều chỉnh giao diện
    final double iconSize = isMini ? 40 : 60;
    final TextStyle? textStyle = isMini
        ? Theme.of(context).textTheme.bodyLarge
        : Theme.of(context).textTheme.titleMedium;
    final EdgeInsets padding = isMini
        ? const EdgeInsets.all(kSpacingM)
        : const EdgeInsets.all(kSpacingL);

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: iconSize,
            ),
            vSpaceM, // Giảm khoảng cách cho phiên bản mini
            Text(
              message,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            vSpaceM, // Giảm khoảng cách cho phiên bản mini
            AppButton(
              text: 'Thử lại',
              onPressed: onRetry,
              isSmall: true,
            ),
          ],
        ),
      ),
    );
  }
}
