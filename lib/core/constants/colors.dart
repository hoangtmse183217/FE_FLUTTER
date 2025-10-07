import 'package:flutter/material.dart';

/// Lớp chứa tất cả màu sắc được sử dụng trong ứng dụng.
/// Giúp đảm bảo tính nhất quán và dễ dàng thay đổi khi cần.
class AppColors {
  // Màu chủ đạo - ấm áp, mời gọi, liên quan đến ẩm thực
  static const Color primary = Color(0xFFE57373); // Đỏ san hô nhạt

  // Màu nhấn - tạo điểm nhấn, tươi mới
  static const Color accent = Color(0xFFFFB74D); // Cam vàng

  // Màu nền chính của các màn hình
  static const Color background = Color(0xFFF5F5F5); // Xám rất nhạt

  // Màu nền của các thành phần như Card, Dialog
  static const Color surface = Color(0xFFFFFFFF); // Trắng

  // Màu văn bản
  static const Color textPrimary = Color(0xFF212121); // Đen đậm
  static const Color textSecondary = Color(0xFF757575); // Xám đậm

  static const Color border = Color(0xFFE0E0E0); // Xám nhạt

  static const Color error = Color(0xFFD32F2F);   // Đỏ
  static const Color success = Color(0xFF2E7D32); // Xanh lá đậm
}