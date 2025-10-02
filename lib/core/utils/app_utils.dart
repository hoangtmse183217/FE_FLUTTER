// lib/core/utils/app_utils.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Bạn cần thêm gói 'url_launcher'

/// Lớp chứa các hàm tiện ích chung cho ứng dụng.
class AppUtils {
  /// Ẩn bàn phím đang mở.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Mở một URL trong trình duyệt hoặc ứng dụng tương ứng.
  /// Trả về true nếu mở thành công, false nếu thất bại.
  static Future<bool> launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(url);
    } else {
      // Có thể log lỗi hoặc hiển thị thông báo ở đây
      return false;
    }
  }

  /// Lấy kích thước màn hình.
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}