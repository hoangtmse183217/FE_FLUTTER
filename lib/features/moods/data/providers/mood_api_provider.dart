import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class MoodApiException implements Exception {
  final String message;
  MoodApiException(this.message);
  @override
  String toString() => message;
}

class MoodApiProvider {
  /// Lấy danh sách tất cả các moods
  Future<List<dynamic>> fetchAllMoods() async {
    final accessToken = await AuthService.getValidAccessToken();

    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.moods);

    try {
      final response = await http.get(
        uri,
        headers: accessToken != null ? {'Authorization': 'Bearer $accessToken'} : {},
      );

      // SỬA ĐỔI: Bọc khối xử lý response trong một try-catch riêng để bắt lỗi format
      try {
        if (response.body.isEmpty) {
          if (response.statusCode >= 200 && response.statusCode < 300) {
            return []; // Trả về danh sách rỗng nếu thành công nhưng body rỗng
          }
          // Ném lỗi nếu body rỗng và status code là lỗi
          throw MoodApiException('Phản hồi từ máy chủ rỗng (Mã: ${response.statusCode})');
        }

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['success'] == true) {
          return responseData['data'] as List<dynamic>;
        } else {
          final errorMessage = responseData['message'] ?? 'Không thể tải danh sách tâm trạng.';
          throw MoodApiException(errorMessage);
        }
      } on FormatException {
        // Bắt lỗi khi server trả về HTML thay vì JSON (thường do server crash)
        throw MoodApiException('Lỗi định dạng từ máy chủ (đã nhận HTML thay vì JSON). Vui lòng kiểm tra trạng thái của backend service `moods`.');
      }

    } on SocketException {
      throw MoodApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw MoodApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      // Bắt lại các lỗi đã được ném ra từ trước
      if (e is MoodApiException) rethrow;
      // Xử lý các lỗi không mong muốn khác
      throw MoodApiException('Lỗi không xác định: ${e.toString()}');
    }
  }
}
