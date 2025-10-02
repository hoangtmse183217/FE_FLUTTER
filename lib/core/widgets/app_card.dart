// lib/core/widgets/app_card.dart
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Sử dụng margin từ tham số hoặc từ theme mặc định
      margin: margin,
      // Cho phép thẻ có thể được nhấn vào
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // Phải khớp với shape của Card
        child: Padding(
          // Sử dụng padding từ tham số hoặc mặc định là 16
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}