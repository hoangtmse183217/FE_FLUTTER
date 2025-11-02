import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class RestaurantApiException implements Exception {
  final String message;
  RestaurantApiException(this.message);
  @override
  String toString() => message;
}

class RestaurantApiProvider {
  final http.Client _client;

  RestaurantApiProvider({http.Client? client}) : _client = client ?? http.Client();

  // ===================================================================
  // HÀM HELPER TRUNG TÂM
  // ===================================================================

  Future<Map<String, String>> _getAuthHeaders() async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw RestaurantApiException('Người dùng chưa đăng nhập hoặc token đã hết hạn.');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  dynamic _processResponse(http.Response response) {
    if (kDebugMode) {
      print('[API DEBUG] ======= RESPONSE =======');
      print('[API DEBUG] Status Code: ${response.statusCode}');
      print('[API DEBUG] Body: ${response.body}');
      print('[API DEBUG] =========================');
    }

    if (response.statusCode == 204) {
      return null; 
    }

    dynamic responseData;
    try {
      if (response.body.isEmpty) {
        // NẾU BODY RỖNG, NÉM LỖI RÕ RÀNG
        throw RestaurantApiException('Phản hồi từ máy chủ rỗng. Mã: ${response.statusCode}');
      }
      responseData = jsonDecode(utf8.decode(response.bodyBytes));
    } catch(e) {
      throw RestaurantApiException('Không thể phân tích phản hồi JSON từ máy chủ. Mã: ${response.statusCode}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
       if (responseData['success'] == true) {
         return responseData['data'];
       } else {
         throw RestaurantApiException(responseData['message'] ?? 'Yêu cầu thành công nhưng backend báo lỗi.');
       }
    }
    throw RestaurantApiException(responseData['message'] ?? 'Lỗi máy chủ. Mã: ${response.statusCode}');
  }

  /// BỔ SUNG LOG CHI TIẾT CHO REQUEST
  void _logRequest(String method, Uri uri, Map<String, String> headers, {Object? body}) {
     if (kDebugMode) {
      print('[API DEBUG] ======= REQUEST =======');
      print('[API DEBUG] Method: $method');
      print('[API DEBUG] URI: $uri');
      print('[API DEBUG] Headers: $headers');
      if (body != null) {
         print('[API DEBUG] Body: ${jsonEncode(body)}');
      }
      print('[API DEBUG] =========================');
    }
  }

  Future<dynamic> _get(Uri uri) async {
    try {
      final headers = await _getAuthHeaders();
      _logRequest('GET', uri, headers);
      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on TimeoutException {
      throw RestaurantApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is RestaurantApiException) rethrow;
      throw RestaurantApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<dynamic> _post(Uri uri, {Object? body}) async {
     try {
      final headers = await _getAuthHeaders();
      _logRequest('POST', uri, headers, body: body);
      final response = await _client.post(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on TimeoutException {
      throw RestaurantApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is RestaurantApiException) rethrow;
      throw RestaurantApiException('Lỗi không xác định: ${e.toString()}');
    }
  }
  
  Future<dynamic> _put(Uri uri, {Object? body}) async {
     try {
      final headers = await _getAuthHeaders();
      _logRequest('PUT', uri, headers, body: body);
      final response = await _client.put(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on TimeoutException {
      throw RestaurantApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is RestaurantApiException) rethrow;
      throw RestaurantApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<dynamic> _delete(Uri uri) async {
     try {
      final headers = await _getAuthHeaders();
      _logRequest('DELETE', uri, headers);
      final response = await _client.delete(uri, headers: headers).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on TimeoutException {
      throw RestaurantApiException('Yêu cầu vượt quá thời gian cho phép.');
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng.');
    } catch (e) {
      if (e is RestaurantApiException) rethrow;
      throw RestaurantApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  // ===================================================================
  // CÁC HÀM API PUBLIC (KHÔNG THAY ĐỔI)
  // ===================================================================

  Future<List<Map<String, dynamic>>> fetchMyRestaurants() async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerRestaurants);
    final data = await _get(uri);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<Map<String, dynamic>> addRestaurant(Map<String, dynamic> data) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerRestaurants);
    final responseData = await _post(uri, body: data);
    return responseData as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRestaurantDetails(String restaurantId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerRestaurantById(restaurantId));
    final responseData = await _get(uri);
    return responseData as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRestaurant(String restaurantId, Map<String, dynamic> data) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerRestaurantById(restaurantId));
    final responseData = await _put(uri, body: data);
    return responseData as Map<String, dynamic>;
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.partnerRestaurantById(restaurantId));
    await _delete(uri);
  }

  Future<Map<String, dynamic>> uploadRestaurantImage(String restaurantId, XFile imageFile) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw RestaurantApiException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.restaurantImages(restaurantId));
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    if (kDebugMode) {
      print('[API DEBUG] ======= MULTIPART REQUEST =======');
      print('[API DEBUG] Method: POST');
      print('[API DEBUG] URI: $uri');
      print('[API DEBUG] Headers: ${request.headers}');
      print('[API DEBUG] =================================');
    }

    try {
      var streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      var response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response) as Map<String, dynamic>;
    } on TimeoutException {
      throw RestaurantApiException('Tải ảnh lên vượt quá thời gian cho phép.');
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng khi tải ảnh.');
    } catch(e) {
      rethrow;
    }
  }

  Future<void> deleteRestaurantImage(String restaurantId, String imageId) async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.restaurantImageById(restaurantId, imageId));
    await _delete(uri);
  }
}
