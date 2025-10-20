import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';

/// --- CÁC LỚP EXCEPTION TÙY CHỈNH ---

/// Exception cho đăng ký
class RegistrationException implements Exception {
  final String message;
  RegistrationException(this.message);
  @override
  String toString() => message;
}

/// Exception cho đăng nhập
class LoginException implements Exception {
  final String message;
  LoginException(this.message);
  @override
  String toString() => message;
}

/// Exception cho quên mật khẩu
class ForgotPasswordException implements Exception {
  final String message;
  ForgotPasswordException(this.message);
  @override
  String toString() => message;
}

/// Exception cho đặt lại mật khẩu
class ResetPasswordException implements Exception {
  final String message;
  ResetPasswordException(this.message);
  @override
  String toString() => message;
}

/// Exception cho làm mới token
class RefreshTokenException implements Exception {
  final String message;
  RefreshTokenException(this.message);
  @override
  String toString() => message;
}

/// --- LỚP GỌI API ---

class AuthApiProvider {
  /// Đăng ký người dùng mới
  Future<void> registerUser({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);

    try {
      final response = await http.post(
        uri,
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        String errorMessage = 'Đã có lỗi xảy ra.';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['errors']?.first ?? errorData['message'] ?? 'Lỗi không xác định.';
        } catch (_) {
          errorMessage = 'Lỗi từ máy chủ (Mã: ${response.statusCode})';
        }
        throw RegistrationException(errorMessage);
      }
    } on SocketException {
      throw RegistrationException('Không có kết nối mạng.');
    } on TimeoutException {
      throw RegistrationException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is RegistrationException) rethrow;
      throw RegistrationException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// Đăng nhập người dùng và trả về dữ liệu
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);

    try {
      final response = await http.post(
        uri,
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Đăng nhập thành công, trả về toàn bộ object 'data'
        return responseData['data'] as Map<String, dynamic>;
      } else {
        // Nếu thất bại, lấy thông điệp lỗi từ API
        final errorMessage = responseData['error'] ?? responseData['message'] ?? 'Đăng nhập thất bại.';
        throw LoginException(errorMessage);
      }
    } on SocketException {
      throw LoginException('Không có kết nối mạng.');
    } on TimeoutException {
      throw LoginException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is LoginException) rethrow;
      throw LoginException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// Đăng nhập bằng token Google và trả về dữ liệu
  Future<Map<String, dynamic>> loginWithGoogleToken({
    required String idToken,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.googleLogin);

    try {
      final response = await http.post(
        uri,
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode({
          'idToken': idToken,
        }),
      ).timeout(const Duration(seconds: 15)); // Tăng timeout một chút cho các cuộc gọi liên quan đến dịch vụ ngoài

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Đăng nhập thành công, trả về toàn bộ object 'data'
        return responseData['data'] as Map<String, dynamic>;
      } else {
        // Xử lý lỗi từ API
        final errorMessage = responseData['error'] ?? responseData['message'] ?? 'Đăng nhập Google thất bại.';
        throw LoginException(errorMessage);
      }
    } on SocketException {
      throw LoginException('Không có kết nối mạng.');
    } on TimeoutException {
      throw LoginException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is LoginException) rethrow;
      throw LoginException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// Đăng xuất người dùng
  Future<void> logoutUser({String? accessToken}) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.logout);

    try {
      // API logout thường yêu cầu token để xác thực
      // Nếu không có token, không cần gọi API
      if (accessToken == null) return;

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken', // Gửi token để xác thực
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('API Logout Success: Token invalidated on server.');
        return;
      } else {
        // Ngay cả khi API thất bại, chúng ta vẫn nên tiếp tục đăng xuất ở client
        print('API Logout Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Bỏ qua lỗi mạng khi logout, vì client vẫn sẽ xóa token
      print('Error calling logout API: $e');
    }
  }

  /// --- SỬA LẠI HÀM NÀY ĐỂ TRẢ VỀ TOKEN ---
  Future<String> requestPasswordReset({required String email}) async {
    final uri = Uri.parse(ApiConstants.baseUrl + '/auth/forgot-password');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['data'] != null && responseData['data']['resetToken'] != null) {
          return responseData['data']['resetToken'] as String;
        } else {
          // Nếu API không trả về token, vẫn coi là thành công
          return '';
        }
      } else {
        final message = responseData['message'] ?? 'Yêu cầu đặt lại mật khẩu thất bại.';
        throw ForgotPasswordException(message);
      }
    } on SocketException {
      throw ForgotPasswordException('Không có kết nối mạng.');
    } on TimeoutException {
      throw ForgotPasswordException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is ForgotPasswordException) rethrow;
      throw ForgotPasswordException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// --- SỬA LẠI HÀM NÀY ĐỂ GỬI THÊM TOKEN ---
  Future<void> resetPassword({
    required String email,
    required String token,
    required String otp,
    required String newPassword,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + '/auth/reset-password');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'otp': otp,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return;
      } else {
        final message = responseData['message'] ?? 'Đặt lại mật khẩu thất bại.';
        throw ResetPasswordException(message);
      }
    } on SocketException {
      throw ResetPasswordException('Không có kết nối mạng.');
    } on TimeoutException {
      throw ResetPasswordException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is ResetPasswordException) rethrow;
      throw ResetPasswordException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// Làm mới token
  Future<Map<String, dynamic>> refreshToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.refresh);
    try {
      final response = await http.post(
        uri,
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        }),
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw RefreshTokenException(responseData['message'] ?? 'Phiên đăng nhập đã hết hạn.');
      }
    } catch (e) {
      throw RefreshTokenException('Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại.');
    }
  }

}