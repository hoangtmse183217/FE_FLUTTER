// lib/core/utils/logger.dart
import 'package:flutter/foundation.dart';

/// Một lớp logger đơn giản để thay thế cho print().
/// Chỉ in ra console ở chế độ debug (khi kDebugMode = true).
class AppLogger {
  /// Log thông tin (màu xanh dương).
  static void info(dynamic message) {
    if (kDebugMode) {
      print('\x1B[34m[INFO] 💡: $message\x1B[0m');
    }
  }

  /// Log thành công (màu xanh lá).
  static void success(dynamic message) {
    if (kDebugMode) {
      print('\x1B[32m[SUCCESS] ✅: $message\x1B[0m');
    }
  }

  /// Log cảnh báo (màu vàng).
  static void warning(dynamic message) {
    if (kDebugMode) {
      print('\x1B[33m[WARNING] ⚠️: $message\x1B[0m');
    }
  }

  /// Log lỗi (màu đỏ).
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('\x1B[31m[ERROR] ❌: $message\x1B[0m');
      if (error != null) {
        print('\x1B[31m$error\x1B[0m');
      }
      if (stackTrace != null) {
        print('\x1B[31m$stackTrace\x1B[0m');
      }
    }
  }
}