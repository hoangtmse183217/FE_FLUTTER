import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class PostApiException implements Exception {
  final String message;
  PostApiException(this.message);
  @override
  String toString() => message;
}

class PostApiProvider {
  Future<Map<String, String>> _getHeaders({bool needsContent = false}) async {
    final accessToken = await AuthService.getValidAccessToken();
    final headers = <String, String>{};
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    if (needsContent) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null; // Body rỗng, trả về null để lớp gọi xử lý
      }
      throw PostApiException('Không tìm thấy API (Mã: ${response.statusCode})');
    }

    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData['success'] == true) {
        return responseData['data']; // Trả về data, có thể là null
      }
      return responseData;
    } else {
      final errorMessage = responseData['message'] ?? 'Lỗi không xác định từ API.';
      throw PostApiException(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getPosts({required int page, int pageSize = 10}) async {
    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.posts).replace(queryParameters: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      final data = _handleResponse(response);
      // Nếu data là null (không có bài viết), trả về cấu trúc phân trang rỗng.
      if (data == null) {
        return {'items': [], 'page': page, 'totalPages': 0};
      }
      return data as Map<String, dynamic>;
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw PostApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi khi tải bài viết: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getPostDetails(int postId) async {
    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.postById(postId));
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      // getPostDetails có thể trả về null nếu không tìm thấy
      return _handleResponse(response) as Map<String, dynamic>?;
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw PostApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi khi tải chi tiết bài viết: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getComments(int postId) async {
    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.postComments(postId));
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      final data = _handleResponse(response);
      // Nếu không có comment, data có thể là null. Trả về list rỗng.
      return (data as List<dynamic>?) ?? [];
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw PostApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi khi tải bình luận: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> addComment(int postId, String content) async {
    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.postComments(postId));
    try {
      final response = await http.post(
        uri,
        headers: await _getHeaders(needsContent: true),
        body: jsonEncode({'content': content}),
      );
      return _handleResponse(response) as Map<String, dynamic>?;
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw PostApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi khi thêm bình luận: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getPostsByRestaurant({
    required int restaurantId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final uri = Uri.parse(ApiConstants.socialUrl + ApiConstants.postsByRestaurant(restaurantId))
        .replace(queryParameters: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      final data = _handleResponse(response);

      // SỬA LỖI: Nếu data là null (nhà hàng không có bài viết), trả về cấu trúc phân trang rỗng.
      if (data == null) {
        return {'items': [], 'page': page, 'totalPages': 0};
      }

      return data as Map<String, dynamic>;
    } on SocketException {
      throw PostApiException('Không có kết nối mạng.');
    } on TimeoutException {
      throw PostApiException('Không thể kết nối đến máy chủ.');
    } catch (e) {
      if (e is PostApiException) rethrow;
      throw PostApiException('Lỗi khi tải bài viết của nhà hàng: ${e.toString()}');
    }
  }
}
