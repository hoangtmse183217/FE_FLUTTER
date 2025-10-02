// lib/core/constants/app_durations.dart

/// Lớp quản lý thời gian cho các hiệu ứng (animation, transition).
/// Giúp ứng dụng có cảm giác mượt mà và nhất quán.
class AppDurations {
  // Thời gian cho các hiệu ứng rất nhanh (ví dụ: fade in/out)
  static const Duration fast = Duration(milliseconds: 150);

  // Thời gian cho các hiệu ứng mặc định (ví dụ: chuyển trang, bung nở widget)
  static const Duration medium = Duration(milliseconds: 300);

  // Thời gian cho các hiệu ứng chậm hơn (ví dụ: các hiệu ứng phức tạp hơn)
  static const Duration slow = Duration(milliseconds: 500);
}