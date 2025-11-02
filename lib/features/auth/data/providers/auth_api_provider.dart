import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

// --- CÁC LỚP EXCEPTION TÙY CHỈNH ---

class RegistrationException implements Exception {
  final String message;
  RegistrationException(this.message);
  @override
  String toString() => message;
}

class LoginException implements Exception {
  final String message;
  LoginException(this.message);
  @override
  String toString() => message;
}

class ForgotPasswordException implements Exception {
  final String message;
  ForgotPasswordException(this.message);
  @override
  String toString() => message;
}

class ResetPasswordException implements Exception {
  final String message;
  ResetPasswordException(this.message);
  @override
  String toString() => message;
}

class RefreshTokenException implements Exception {
  final String message;
  RefreshTokenException(this.message);
  @override
  String toString() => message;
}

class ChangePasswordException implements Exception {
  final String message;
  ChangePasswordException(this.message);
  @override
  String toString() => message;
}

// --- LỚP GỌI API ---

class AuthApiProvider {
  Future<void> registerUser({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);
    await _handlePostRequest(uri, {
      'fullname': fullname,
      'email': email,
      'password': password,
    }, (e) => RegistrationException(e));
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
    return await _handlePostRequest(uri, {
      'email': email,
      'password': password,
    }, (e) => LoginException(e));
  }

  Future<Map<String, dynamic>> loginWithGoogleToken({required String idToken}) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.googleLogin);
    return await _handlePostRequest(uri, {'idToken': idToken}, (e) => LoginException(e), timeout: 15);
  }

  Future<void> logoutUser({String? accessToken}) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.logout);
    try {
      if (accessToken == null) return;
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      print('Error calling logout API: $e');
    }
  }

  Future<String> requestPasswordReset({required String email}) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.forgotPassword); // SỬA
    final response = await _handlePostRequest(uri, {'email': email}, (e) => ForgotPasswordException(e));
    return response['data']?['resetToken'] ?? '';
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String otp,
    required String newPassword,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.resetPassword); // SỬA
    await _handlePostRequest(uri, {
      'email': email,
      'token': token,
      'otp': otp,
      'newPassword': newPassword,
    }, (e) => ResetPasswordException(e));
  }

  Future<Map<String, dynamic>> refreshToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.refresh);
    try {
      return await _handlePostRequest(uri, {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }, (e) => RefreshTokenException(e));
    } catch (e) {
      throw RefreshTokenException('Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại.');
    }
  }

  Future<Map<String, dynamic>> registerPartner({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.registerPartner);
    return await _handlePostRequest(uri, {
      'fullname': fullname,
      'email': email,
      'password': password,
    }, (e) => RegistrationException(e));
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ChangePasswordException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.changePassword); // SỬA
    await _handlePostRequest(uri, {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    }, (e) => ChangePasswordException(e), token: accessToken);
  }

  // --- Helper Method for POST Requests ---
  Future<dynamic> _handlePostRequest(
    Uri uri,
    Map<String, dynamic> body,
    Function(String) exceptionBuilder,
    { int timeout = 10, String? token }
  ) async {
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeout));

      // Handle empty response body
      if (response.body.isEmpty) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return; // Success with no content
        }
        throw exceptionBuilder('Lỗi từ máy chủ (Mã: ${response.statusCode})');
      }
      
      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && (responseData['success'] == true || responseData['success'] == null)) {
         // For endpoints that don't return a 'data' key (like simple register)
        return responseData.containsKey('data') ? responseData['data'] : null;
      } else {
        final errorMessage = responseData['message'] ?? responseData['errors']?.first ?? 'Lỗi không xác định.';
        throw exceptionBuilder(errorMessage);
      }
    } on SocketException {
      throw exceptionBuilder('Không có kết nối mạng.');
    } on TimeoutException {
      throw exceptionBuilder('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e.runtimeType == exceptionBuilder('').runtimeType) rethrow;
      throw exceptionBuilder('Lỗi không xác định: ${e.toString()}');
    }
  }
}
