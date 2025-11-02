import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class PostApiException implements Exception {
  final String message;
  PostApiException(this.message);
  @override
  String toString() => message;
}


class PostApiProvider {
  final http.Client _client;

  PostApiProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, String>> _getAuthHeaders() async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw PostApiException('Người dùng chưa đăng nhập hoặc token đã hết hạn.');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  void _logRequest(String method, Uri uri, Map<String, String> headers, {Object? body}) {
     if (kDebugMode) {
      print('[API DEBUG] ======= POST REQUEST =======');
      print('[API DEBUG] Method: $method');
      print('[API DEBUG] URI: $uri');
      print('[API DEBUG] Headers: $headers');
      if (body != null) {
         print('[API DEBUG] Body: ${jsonEncode(body)}');
      }
      print('[API DEBUG] ============================');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (kDebugMode) {
      print('[API DEBUG] ======= POST RESPONSE =======');
      print('[API DEBUG] Status Code: ${response.statusCode}');
      print('[API DEBUG] Body: ${response.body}');
      print('[API DEBUG] =============================');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204 || response.body.isEmpty) {
        return null; 
      }
      try {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw PostApiException(responseData['message'] ?? 'Yêu cầu thành công nhưng backend báo lỗi.');
        }
      } catch (e) {
        throw PostApiException('Không thể phân tích phản hồi JSON hợp lệ từ máy chủ.');
      }
    } else {
      throw PostApiException('Máy chủ gặp lỗi. Mã: ${response.statusCode}');
    }
  }


  Future<dynamic> _get(Uri uri) async {
    try {
      final headers = await _getAuthHeaders();
      _logRequest('GET', uri, headers);
      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on TimeoutException {
      throw PostApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<dynamic> _post(Uri uri, {Object? body}) async {
     try {
      final headers = await _getAuthHeaders();
       _logRequest('POST', uri, headers, body: body);
      final response = await _client.post(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on TimeoutException {
      throw PostApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<dynamic> _put(Uri uri, {Object? body}) async {
     try {
      final headers = await _getAuthHeaders();
      _logRequest('PUT', uri, headers, body: body);
      final response = await _client.put(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on TimeoutException {
      throw PostApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<dynamic> _delete(Uri uri) async {
     try {
      final headers = await _getAuthHeaders();
      _logRequest('DELETE', uri, headers);
      final response = await _client.delete(uri, headers: headers).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on TimeoutException {
      throw PostApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchMyPosts({int page = 1, int pageSize = 10}) async {
    final cacheBuster = DateTime.now().millisecondsSinceEpoch.toString();
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPosts)
        .replace(queryParameters: {
          'page': page.toString(), 
          'pageSize': pageSize.toString(),
          '_': cacheBuster,
        });
    final data = await _get(uri);
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> addPost(Map<String, dynamic> data) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPosts);
    final responseData = await _post(uri, body: data);
    return responseData as Map<String, dynamic>;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostById(postId));
    await _put(uri, body: data);
  }

  Future<void> deletePost(String postId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostById(postId));
    await _delete(uri);
  }

  Future<Map<String, dynamic>> getPostDetails(String postId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostById(postId));
    final data = await _get(uri);
    return data as Map<String, dynamic>;
  }
  
  Future<void> addMoodToPost(String postId, int moodId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostMood(postId, moodId));
    await _post(uri);
  }

  Future<void> removeMoodFromPost(String postId, int moodId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostMood(postId, moodId));
    await _delete(uri);
  }

  Future<String> uploadPostImage(String postId, XFile imageFile) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw PostApiException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerPostImage(postId));
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      var response = await http.Response.fromStream(streamedResponse);
      final data = _processResponse(response) as Map<String, dynamic>;
      return data['imageUrl'] as String;
    } on TimeoutException {
      throw PostApiException('Tải ảnh lên vượt quá thời gian cho phép.');
    } on SocketException {
      throw PostApiException('Không có kết nối mạng khi tải ảnh.');
    } catch(e) {
      rethrow;
    }
  }
}
