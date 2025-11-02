import 'dart:async';
import 'dart:convert';
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
  /// Lấy danh sách reviews của một nhà hàng
  Future<Map<String, dynamic>> fetchReviews(String restaurantId, {int page = 1, int pageSize = 10}) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ReviewApiException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.discoveryUrl + ApiConstants.partnerRestaurantReviews(restaurantId))
        .replace(queryParameters: {'page': page.toString(), 'pageSize': pageSize.toString()});

    try {
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $accessToken'});
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw ReviewApiException(responseData['message'] ?? 'Không thể tải danh sách đánh giá.');
      }
    } catch (e) {
      if (e is ReviewApiException) rethrow;
      throw ReviewApiException('Lỗi không xác định: ${e.toString()}');
    }
  }

  /// Gửi phản hồi cho một review
  Future<Map<String, dynamic>> replyToReview(int reviewId, String comment) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ReviewApiException('Chưa đăng nhập.');

    final uri = Uri.parse(ApiConstants.discoveryUrl + ApiConstants.partnerReplyToReview(reviewId));
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $accessToken'},
        body: jsonEncode({'comment': comment}),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw ReviewApiException(responseData['message'] ?? 'Gửi phản hồi thất bại.');
      }
    } catch (e) {
      if (e is ReviewApiException) rethrow;
      throw ReviewApiException('Lỗi không xác định: ${e.toString()}');
    }
  }
}
