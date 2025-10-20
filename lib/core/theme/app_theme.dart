import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

enum AppThemeOptions {
  light,
  dark,
  warm,
  ocean,
  forest,
  aurora,
}

/// Định nghĩa chủ đề giao diện chung cho toàn bộ ứng dụng.
class AppTheme {
  // --- CHỦ ĐỀ MẶC ĐỊNH (SÁNG) ---
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.surface,
      onSecondary: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.surface,
    ),
    // ... (Các cấu hình khác của lightTheme)
  );

  // --- CHỦ ĐỀ TỐI ---
  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      error: AppColors.error,
      onPrimary: AppColors.surface,
      onSecondary: AppColors.textPrimary,
      onBackground: AppColors.surface,
      onSurface: AppColors.surface,
      onError: AppColors.surface,
    ),
    // ... (Các cấu hình khác của darkTheme)
  );

  // --- CHỦ ĐỀ ẤM ---
  static final ThemeData warmTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.warmPrimary,
      secondary: AppColors.warmAccent,
      background: AppColors.warmBackground,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.surface,
      onSecondary: AppColors.warmText,
      onBackground: AppColors.warmText,
      onSurface: AppColors.warmText,
      onError: AppColors.surface,
    ),
    // ... (Tùy chỉnh thêm nếu cần)
  );

  // --- CHỦ ĐỀ BIỂN (ĐÃ CẢI TIẾN) ---
  static final ThemeData oceanTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.oceanPrimary,
      secondary: AppColors.oceanAccent,
      background: AppColors.oceanBackground,
      surface: AppColors.oceanSurface,
      error: AppColors.error,
      onPrimary: AppColors.oceanText,
      onSecondary: AppColors.oceanBackground,
      onBackground: AppColors.oceanText,
      onSurface: AppColors.oceanText,
      onError: AppColors.oceanBackground,
    ),
    // ... (Tùy chỉnh thêm nếu cần)
  );

  // --- CHỦ ĐỀ RỪNG ---
  static final ThemeData forestTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.forestPrimary,
      secondary: AppColors.forestAccent,
      background: AppColors.forestBackground,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.surface,
      onSecondary: AppColors.forestText,
      onBackground: AppColors.forestText,
      onSurface: AppColors.forestText,
      onError: AppColors.surface,
    ),
    // ... (Tùy chỉnh thêm nếu cần)
  );

  // --- CHỦ ĐỀ CỰC QUANG (ĐÃ CẢI TIẾN) ---
  static final ThemeData auroraTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.auroraPrimary,
      secondary: AppColors.auroraAccent,
      background: AppColors.auroraBackground,
      surface: AppColors.auroraSurface,
      error: AppColors.error,
      onPrimary: AppColors.auroraText,
      onSecondary: AppColors.auroraBackground,
      onBackground: AppColors.auroraText,
      onSurface: AppColors.auroraText,
      onError: AppColors.auroraBackground,
    ),
    // ... (Tùy chỉnh thêm nếu cần)
  );


  static ThemeData getTheme(AppThemeOptions option) {
    switch (option) {
      case AppThemeOptions.dark:
        return darkTheme;
      case AppThemeOptions.warm:
        return warmTheme;
      case AppThemeOptions.ocean:
        return oceanTheme;
      case AppThemeOptions.forest:
        return forestTheme;
      case AppThemeOptions.aurora:
        return auroraTheme;
      case AppThemeOptions.light:
      default:
        return lightTheme;
    }
  }
}
