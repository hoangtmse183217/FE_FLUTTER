import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class ReviewApiException implements Exception {
  final String message;
  ReviewApiException(this.message);
  @override
  String toString() => message;
}

class ReviewApiProvider {
  final http.Client _client;

  ReviewApiProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> _handleApiCall(Future<http.Response> apiCall) async {
    try {
      final response = await apiCall.timeout(const Duration(seconds: 15));

      if (response.bodyBytes.isEmpty) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return {'success': true, 'data': null};
        } else {
          throw ReviewApiException('Lỗi từ máy chủ (mã ${response.statusCode})');
        }
      }

      final responseData = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw ReviewApiException(responseData['errors']?.join(', ') ?? 'An unknown error occurred');
        }
      } else {
        throw ReviewApiException(responseData['message'] ?? 'Error ${response.statusCode}');
      }
    } on SocketException {
      throw ReviewApiException('Không có kết nối mạng. Vui lòng thử lại.');
    } on TimeoutException {
      throw ReviewApiException('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.');
    } on FormatException {
      throw ReviewApiException('Lỗi phân tích dữ liệu từ máy chủ.');
    } catch (e) {
      if (e is ReviewApiException) rethrow;
      throw ReviewApiException('Đã có lỗi không mong muốn xảy ra: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getReviewsByRestaurant({
    required int restaurantId,
    required int page,
    required int pageSize,
  }) async {
    // SỬA LỖI: Sử dụng đúng endpoint
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/reviews/by-restaurant/$restaurantId?page=$page&pageSize=$pageSize');
    final token = await AuthService.getValidAccessToken();
    final headers = {'Authorization': 'Bearer $token'};
    return _handleApiCall(http.get(uri, headers: headers));
  }

  Future<Map<String, dynamic>> addReview({
    required int restaurantId,
    required int rating,
    required String comment,
  }) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/reviews/for-restaurant/$restaurantId');
    final token = await AuthService.getValidAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'rating': rating, 'comment': comment});
    return _handleApiCall(http.post(uri, headers: headers, body: body));
  }

  Future<Map<String, dynamic>> updateReview({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/reviews/$reviewId');
    final token = await AuthService.getValidAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'rating': rating, 'comment': comment});
    return _handleApiCall(http.put(uri, headers: headers, body: body));
  }

  Future<void> deleteReview(int reviewId) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/reviews/$reviewId');
    final token = await AuthService.getValidAccessToken();
    final headers = {'Authorization': 'Bearer $token'};
    await _handleApiCall(http.delete(uri, headers: headers));
  }
}
