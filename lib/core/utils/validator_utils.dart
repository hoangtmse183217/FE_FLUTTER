// lib/core/utils/validator_utils.dart

/// Lớp chứa các hàm tiện ích để kiểm tra (validate) dữ liệu đầu vào.
class ValidatorUtils {
  /// Kiểm tra xem giá trị có rỗng không.
  static String? notEmpty(String? value, {String message = 'Vui lòng không để trống'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Kiểm tra định dạng email.
  static String? email(String? value, {String message = 'Email không hợp lệ'}) {
    final emptyCheck = notEmpty(value);
    if (emptyCheck != null) {
      return emptyCheck;
    }
    // Sử dụng biểu thức chính quy (Regex) để kiểm tra email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value!)) {
      return message;
    }
    return null;
  }

  /// Kiểm tra mật khẩu.
  /// Yêu cầu: Ít nhất 8 ký tự, có ít nhất một chữ cái và một số.
  static String? password(String? value, {String message = 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ và số'}) {
    final emptyCheck = notEmpty(value);
    if (emptyCheck != null) {
      return emptyCheck;
    }
    if (value!.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự.';
    }
    // Kiểm tra có chứa ít nhất một chữ cái
    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái.';
    }
    // Kiểm tra có chứa ít nhất một chữ số
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ số.';
    }
    return null;
  }
}