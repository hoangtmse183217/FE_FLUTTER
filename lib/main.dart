import 'package:flutter/material.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng MaterialApp.router để tích hợp GoRouter
    return MaterialApp.router(
      // Tắt banner "Debug" ở góc trên bên phải
      debugShowCheckedModeBanner: false,

      // Lấy tiêu đề từ file constants để dễ quản lý
      title: AppStrings.appName,

      // Áp dụng theme đã được định nghĩa trong core/theme
      theme: AppTheme.lightTheme,

      // Cung cấp cấu hình router cho ứng dụng.
      // Đây là bước quan trọng nhất để kích hoạt GoRouter.
      // Thuộc tính 'home' không còn cần thiết nữa.
      routerConfig: AppRouter.router,
    );
  }
}