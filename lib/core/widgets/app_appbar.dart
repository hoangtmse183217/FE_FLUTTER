// lib/core/widgets/app_appbar.dart
import 'package:flutter/material.dart';

// implement PreferredSizeWidget để AppBar có kích thước chuẩn
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const AppAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      // Các thuộc tính khác như backgroundColor, elevation... sẽ tự động
      // lấy từ appBarTheme đã định nghĩa trong app_theme.dart
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}