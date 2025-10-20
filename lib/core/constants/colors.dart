import 'package:flutter/material.dart';

/// Lớp chứa tất cả màu sắc được sử dụng trong ứng dụng.
/// Giúp đảm bảo tính nhất quán và dễ dàng thay đổi khi cần.
class AppColors {
  // --- Bảng màu mặc định (Light) ---
  static const Color primary = Color(0xFFE57373);
  static const Color accent = Color(0xFFFFB74D);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);

  // --- Bảng màu chủ đề WARM ---
  static const Color warmPrimary = Color(0xFFB77466);
  static const Color warmAccent = Color(0xFFE2B59A);
  static const Color warmBackground = Color(0xFFFFF9E9);
  static const Color warmText = Color(0xFF5D4037);

  // --- Bảng màu chủ đề OCEAN (Đã cải tiến) ---
  static const Color oceanPrimary = Color(0xFF00A0B0);  // Bright Teal
  static const Color oceanAccent = Color(0xFFFFC107);   // Amber
  static const Color oceanBackground = Color(0xFF003B46); // Deep Blue-Green
  static const Color oceanSurface = Color(0xFF07575B);  // Dark Teal
  static const Color oceanText = Color(0xFFE0FBFC);     // Light Cyan

  // --- Bảng màu chủ đề FOREST ---
  static const Color forestPrimary = Color(0xFF3B7A57);
  static const Color forestAccent = Color(0xFFA8C686);
  static const Color forestBackground = Color(0xFFF1ECCE);
  static const Color forestText = Color(0xFF2F4F4F);

  // --- Bảng màu chủ đề AURORA (Đã cải tiến) ---
  static const Color auroraPrimary = Color(0xFFBE00FE);   // Neon Purple
  static const Color auroraAccent = Color(0xFF00F5D4);    // Neon Teal
  static const Color auroraBackground = Color(0xFF0B0725); // Midnight Indigo
  static const Color auroraSurface = Color(0xFF352B5A);  // Deep Purple
  static const Color auroraText = Color(0xFFE4DFFF);      // Lavender White
}
