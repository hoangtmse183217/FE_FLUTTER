import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class ChatApiProvider {
  Future<Map<String, dynamic>> sendMessage(String message) async {
    // SỬA LỖI: Sử dụng đúng hằng số aiUrl và aiChatFood, không hardcode path
    final url = Uri.parse(ApiConstants.aiUrl + ApiConstants.aiChatFood);
    final token = await AuthService.getValidAccessToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(data['message'] ?? 'Failed to get chat response');
      }
    } else {
      // Cải thiện thông báo lỗi để rõ ràng hơn
      throw Exception('Lỗi gửi tin nhắn, mã lỗi: ${response.statusCode}');
    }
  }
}
