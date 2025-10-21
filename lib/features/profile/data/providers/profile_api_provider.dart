import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

// Lớp Exception tùy chỉnh cho các lỗi liên quan đến Profile
class ProfileException implements Exception {
  final String message;
  ProfileException(this.message);
  @override
  String toString() => message;
}

class ProfileApiProvider {
  /// Lấy thông tin chi tiết của người dùng đang đăng nhập
  Future<Map<String, dynamic>> getMyProfile() async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) {
      throw ProfileException('Chưa đăng nhập hoặc phiên đã hết hạn.');
    }

    final uri = Uri.parse(ApiConstants.baseUrl + '/profile/me');

    try {
      final response = await http.get(
        uri,
        headers: { 'Authorization': 'Bearer $accessToken' },
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      // Sửa lại: Kiểm tra 'success' thay vì 'isSuccess'
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Trả về dữ liệu thành công, kể cả khi profile là null
        return responseData['data'] as Map<String, dynamic>;
      } else {
        // Nếu API trả về lỗi (statusCode != 200 hoặc success == false)
        final errorMessage = responseData['message'] ?? responseData['errors']?.first ?? 'Không thể tải hồ sơ.';
        throw ProfileException(errorMessage);
      }
    } on SocketException {
      throw ProfileException('Không có kết nối mạng. Vui lòng kiểm tra lại.');
    } on TimeoutException {
      throw ProfileException('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.');
    } catch (e) {
      // Ném lại các lỗi đã được xử lý (ProfileException) hoặc các lỗi không mong muốn khác
      rethrow;
    }
  }

  /// Cập nhật thông tin hồ sơ
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) {
      throw ProfileException('Chưa đăng nhập hoặc phiên đã hết hạn.');
    }

    final uri = Uri.parse(ApiConstants.baseUrl + '/profile/me');
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(profileData),
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      // Sửa lại: Kiểm tra 'success' thay vì 'isSuccess'
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = responseData['message'] ?? responseData['errors']?.first ?? 'Cập nhật hồ sơ thất bại.';
        throw ProfileException(errorMessage);
      }
    } on SocketException {
      throw ProfileException('Không có kết nối mạng.');
    } on TimeoutException {
      throw ProfileException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      rethrow;
    }
  }

  /// Tải lên ảnh đại diện
  Future<String> uploadAvatar(XFile imageFile) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ProfileException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.baseUrl + '/profile/avatar');

    try {
      // 1. Tạo một multipart request
      var request = http.MultipartRequest('POST', uri);

      // 2. Thêm headers, đặc biệt là Authorization
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Content-Type'] = 'multipart/form-data';

      // 3. Thêm file vào request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Tên field này phải khớp với backend ("IFormFile file")
          imageFile.path,
        ),
      );

      // 4. Gửi request và chờ response
      var streamedResponse = await request.send().timeout(const Duration(seconds: 30)); // Tăng timeout cho việc upload file

      // 5. Đọc và giải mã response
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['isSuccess'] == true) {
        // Trả về URL của ảnh mới
        return responseData['data']['avatarUrl'] as String;
      } else {
        // Xử lý lỗi từ server
        final errorMessage = responseData['message'] ?? responseData['errors']?.first ?? 'Tải ảnh lên thất bại.';
        throw ProfileException(errorMessage);
      }
    } on SocketException {
      throw ProfileException('Không có kết nối mạng.');
    } on TimeoutException {
      throw ProfileException('Tải ảnh lên quá lâu. Vui lòng thử lại.');
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Lỗi không xác định khi tải ảnh.');
    }
  }
}