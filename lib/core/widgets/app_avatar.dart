// lib/core/widgets/app_avatar.dart
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class AppAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const AppAvatar({
    Key? key,
    required this.imageUrl,
    this.radius = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.border,
      // Dùng NetworkImage để tải ảnh từ URL
      // FadeInImage giúp hiển thị ảnh mờ dần đẹp mắt
      backgroundImage: NetworkImage(imageUrl),
      // Xử lý lỗi nếu không tải được ảnh
      onBackgroundImageError: (exception, stackTrace) {
        // Có thể log lỗi ra đây
      },
      // Hiển thị một icon mặc định nếu ảnh bị lỗi
      child: Builder(builder: (context) {
        final imageProvider = NetworkImage(imageUrl);
        return CircleAvatar(
          backgroundImage: imageProvider,
          onBackgroundImageError: (e, s) {},
          child:
          // Nếu không có child nào được cung cấp và ảnh lỗi, hiển thị icon
          const Icon(Icons.person, color: AppColors.textSecondary),
        );
      }),
    );
  }
}