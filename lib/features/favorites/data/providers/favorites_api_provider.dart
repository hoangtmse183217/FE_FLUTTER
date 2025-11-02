import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';

class FavoritesApiException implements Exception {
  final String message;
  FavoritesApiException(this.message);
}

class FavoritesApiProvider {
  final http.Client _client;
  // final AuthService _authService; // Không cần thiết vì getValidAccessToken là static

  FavoritesApiProvider({http.Client? client, AuthService? authService})
      : _client = client ?? http.Client();
        // _authService = authService ?? AuthService();

  Future<Map<String, dynamic>> getMyFavorites() async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}${ApiConstants.myFavorites}');
    return _handleApiCall(uri, method: 'GET');
  }

  Future<Map<String, dynamic>> addFavorite(int restaurantId) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}${ApiConstants.toggleFavorite(restaurantId)}');
    return _handleApiCall(uri, method: 'POST');
  }

  Future<Map<String, dynamic>> removeFavorite(int restaurantId) async {
    final uri = Uri.parse('${ApiConstants.discoveryUrl}${ApiConstants.toggleFavorite(restaurantId)}');
    return _handleApiCall(uri, method: 'DELETE');
  }

  Future<Map<String, dynamic>> _handleApiCall(Uri uri, {String method = 'GET'}) async {
    try {
      // SỬA LỖI: Gọi phương thức static trực tiếp từ class
      final token = await AuthService.getValidAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      http.Response response;
      switch (method) {
        case 'POST':
          response = await _client.post(uri, headers: headers);
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
          break;
        default:
          response = await _client.get(uri, headers: headers);
      }

      final responseData = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300 && responseData['success'] == true) {
        return responseData;
      } else {
        throw FavoritesApiException(responseData['errors']?.join(', ') ?? 'An API error occurred');
      }
    } on SocketException {
      throw FavoritesApiException('No internet connection');
    } on FormatException {
      throw FavoritesApiException('Failed to parse server response');
    } catch (e) {
      if (e is FavoritesApiException) rethrow;
      throw FavoritesApiException(e.toString());
    }
  }
}
