// lib/core/utils/format_utils.dart
import 'package:intl/intl.dart'; // Bạn cần thêm gói 'intl' vào pubspec.yaml

/// Lớp chứa các hàm tiện ích để định dạng dữ liệu.
class FormatUtils {
  /// Định dạng thời gian nấu ăn từ phút sang chuỗi dễ đọc.
  /// Ví dụ: 75 -> "1 giờ 15 phút"
  static String cookingTime(int minutes) {
    if (minutes <= 0) {
      return "0 phút";
    }
    if (minutes < 60) {
      return "$minutes phút";
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return "$hours giờ";
      }
      return "$hours giờ $remainingMinutes phút";
    }
  }

  /// Định dạng số với dấu phẩy ngăn cách hàng nghìn.
  /// Ví dụ: 1234567 -> "1,234,567"
  static String number(num number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  /// Định dạng ngày tháng theo kiểu "dd/MM/yyyy".
  /// Ví dụ: DateTime.now() -> "02/10/2025"
  static String date(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Định dạng ngày tháng và thời gian theo kiểu "HH:mm dd/MM/yyyy".
  /// Ví dụ: DateTime.now() -> "04:01 02/10/2025"
  static String dateTime(DateTime date) {
    final formatter = DateFormat('HH:mm dd/MM/yyyy');
    return formatter.format(date);
  }
}