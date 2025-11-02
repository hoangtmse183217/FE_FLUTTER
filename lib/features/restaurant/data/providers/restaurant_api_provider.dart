import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

  RestaurantApiProvider({http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getRestaurants({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/restaurants?page=$page&pageSize=$pageSize');
    final responseData = await _handleApiCall(uri);
    return responseData['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRestaurantDetails(int restaurantId) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/restaurants/$restaurantId');
    final responseData = await _handleApiCall(uri);
    return responseData;
  }
  
  Future<Map<String, dynamic>> getNearbyRestaurants({
    required double lat,
    required double lng,
    double radiusKm = 5,
    int limit = 50,
  }) async {
    final params = {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radiusKm': radiusKm.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('${ApiConstants.discoveryUrl}/restaurants/nearby').replace(queryParameters: params);
    final responseData = await _handleApiCall(uri);
    return responseData;
  }

  Future<Map<String, dynamic>> searchRestaurants({
    String? q,
    double? lat,
    double? lng,
    double? radiusKm,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int page = 1,
    int pageSize = 20,
  }) async {
    // SỬA LỖI: Sử dụng ?.toString() để xử lý đúng giá trị null
    final params = {
      'q': q,
      'lat': lat?.toString(),
      'lng': lng?.toString(),
      'radiusKm': radiusKm?.toString(),
      'minPrice': minPrice?.toString(),
      'maxPrice': maxPrice?.toString(),
      'minRating': minRating?.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    }..removeWhere((key, value) => value == null || value.isEmpty);

    final uri = Uri.parse('${ApiConstants.discoveryUrl}/restaurants/search').replace(queryParameters: params);

    final responseData = await _handleApiCall(uri);
    return responseData['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _handleApiCall(Uri uri) async {
    try {
      final token = await AuthService.getValidAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw RestaurantApiException(
              responseData['errors']?.join(', ') ?? 'An unknown error occurred with success:false');
        }
      } else {
        String errorMessage = 'Error ${response.statusCode}';
        try {
          final errorData = json.decode(utf8.decode(response.bodyBytes));
          errorMessage = errorData['message'] ?? errorData['errors']?.join(', ') ?? errorMessage;
        } catch (_e) {
          errorMessage = response.body.substring(0, (response.body.length > 200) ? 200 : response.body.length);
        }
        throw RestaurantApiException(errorMessage);
      }
    } on SocketException {
      throw RestaurantApiException('Không có kết nối mạng. Vui lòng thử lại.');
    } on TimeoutException {
      throw RestaurantApiException('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.');
    } on FormatException {
      throw RestaurantApiException('Lỗi phân tích dữ liệu từ máy chủ.');
    } catch (e) {
      if (e is RestaurantApiException) rethrow;
      throw RestaurantApiException('Đã có lỗi không mong muốn xảy ra: ${e.toString()}');
    }
  }
}
