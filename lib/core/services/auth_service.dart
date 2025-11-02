import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  static final _authStreamController = StreamController<bool>.broadcast();
  static Stream<bool> get authStateChanges => _authStreamController.stream;

  static Future<String?>? _refreshTokenFuture;

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (!_authStreamController.isClosed) {
      _authStreamController.add(true);
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<int?> getCurrentUserId() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) return null;

      final decodedToken = JwtDecoder.decode(accessToken);
      final userId = decodedToken['user_id'];
      if (userId is String) {
        return int.tryParse(userId);
      }
      if (userId is int) {
        return userId;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi giải mã token hoặc không tìm thấy user_id: $e');
      }
      return null;
    }
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    if (!_authStreamController.isClosed) {
      _authStreamController.add(false);
    }
  }

  static Future<String?> _performTokenRefresh() async {
    try {
      final String? oldAccessToken = await getAccessToken();
      final String? refreshToken = await getRefreshToken();

      if (oldAccessToken == null || refreshToken == null) {
        throw Exception('Không tìm thấy token để làm mới.');
      }

      final apiProvider = AuthApiProvider();
      final newData = await apiProvider.refreshToken(
        accessToken: oldAccessToken,
        refreshToken: refreshToken,
      );

      final newAccessToken = newData['accessToken'] as String;
      final newRefreshToken = newData['refreshToken'] as String;

      await saveTokens(newAccessToken, newRefreshToken);
      if (kDebugMode) {
        print("Làm mới token thành công.");
      }
      return newAccessToken;

    } catch (e) {
      if (kDebugMode) {
        print("Làm mới token thất bại: $e. Đang đăng xuất người dùng.");
      }
      await clearTokens();
      return null;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  static Future<String?> getValidAccessToken() async {
    if (_refreshTokenFuture != null) {
      if (kDebugMode) {
        print("Đang có một quá trình làm mới token, đang chờ kết quả...");
      }
      return _refreshTokenFuture;
    }

    final accessToken = await getAccessToken();

    // THÊM LOG DEBUG TOKEN THEO YÊU CẦU
    if (kDebugMode) {
      print("--- DEBUG AUTH_SERVICE ---");
      print("Token load từ storage: $accessToken");
    }

    if (accessToken == null) {
      return null; // Chưa đăng nhập
    }

    final isTokenExpired = JwtDecoder.isExpired(accessToken) || JwtDecoder.getRemainingTime(accessToken).inMinutes < 2;

    if (isTokenExpired) {
      if (kDebugMode) {
        print("Token hết hạn, bắt đầu quá trình làm mới duy nhất.");
      }
      _refreshTokenFuture = _performTokenRefresh();
      return _refreshTokenFuture;
    }

    return accessToken; // Token vẫn còn hạn
  }

  static Future<bool> isAccessTokenValid() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;
    return !JwtDecoder.isExpired(accessToken);
  }

  static void dispose() {
    _authStreamController.close();
  }
}
