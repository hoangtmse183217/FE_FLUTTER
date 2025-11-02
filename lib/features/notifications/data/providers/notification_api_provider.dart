import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class NotificationApiException implements Exception {
  final String message;
  NotificationApiException(this.message);

  @override
  String toString() => message;
}

String _parseErrorMessage(http.Response response) {
  if (response.body.isNotEmpty) {
    try {
      final responseData = jsonDecode(response.body);
      if (responseData is Map && responseData.containsKey('message') && responseData['message'] != null) {
        return responseData['message'] as String;
      }
    } catch (e) {
      return response.body.length < 100 ? response.body : 'Lỗi không thể đọc được từ máy chủ.';
    }
  }
  return 'Lỗi ${response.statusCode}: Máy chủ không có phản hồi nội dung.';
}

class NotificationApiProvider {

  // SỬA LỖI: API trả về một List, không phải Map.
  Future<List<dynamic>> getNotifications() async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) {
      throw NotificationApiException('Chưa đăng nhập');
    }
    
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.notifications);
    final headers = { 'Authorization': 'Bearer $accessToken' };

    if (kDebugMode) {
      print('[API DEBUG] ======= REQUEST =======');
      print('[API DEBUG] Method: GET');
      print('[API DEBUG] URI: $uri');
      print('[API DEBUG] Headers: $headers');
    }

    final response = await http.get(uri, headers: headers);

    if (kDebugMode) {
      print('[API DEBUG] ======= RESPONSE =======');
      print('[API DEBUG] Status Code: ${response.statusCode}');
      print('[API DEBUG] Body: ${response.body}');
      print('[API DEBUG] =========================');
    }
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // API trả về một List, nên ta cast sang List<dynamic>
        return data['data'] as List<dynamic>;
      }
    }
    throw NotificationApiException(_parseErrorMessage(response));
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) {
      throw NotificationApiException('Chưa đăng nhập');
    }
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationById(notificationId));
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }
    throw NotificationApiException(_parseErrorMessage(response));
  }

  Future<void> markAllNotificationsAsRead() async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) {
      throw NotificationApiException('Chưa đăng nhập');
    }
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.readAllNotifications);
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }
    throw NotificationApiException(_parseErrorMessage(response));
  }
}
