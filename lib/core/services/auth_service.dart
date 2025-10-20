import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// Import ApiProvider để có thể gọi API refresh
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  /// Hàm lưu và lấy token từ FlutterSecureStorage
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Hàm lấy access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Hàm lưu và lấy refresh token từ FlutterSecureStorage
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Hàm lấy refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Hàm xóa cả hai token khi đăng xuất
  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Hàm kiểm tra và làm mới access token nếu cần
  static Future<String?> getValidAccessToken() async {
    String? accessToken = await getAccessToken();
    String? refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null; // Không có token, chưa đăng nhập
    }

    // Kiểm tra xem accessToken có sắp hết hạn không (ví dụ: còn dưới 2 phút)
    if (JwtDecoder.isExpired(accessToken) ||
        JwtDecoder.getRemainingTime(accessToken).inMinutes < 2)
    {
      print("Access token sắp hết hạn, đang làm mới...");
      try {
        final apiProvider = AuthApiProvider();
        final newData = await apiProvider.refreshToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        // Lưu lại cặp token mới
        final newAccessToken = newData['accessToken'] as String;
        final newRefreshToken = newData['refreshToken'] as String;
        await saveAccessToken(newAccessToken);
        await saveRefreshToken(newRefreshToken);

        print("Làm mới token thành công.");
        return newAccessToken; // Trả về token mới

      } catch (e) {
        print("Làm mới token thất bại: $e. Đang đăng xuất người dùng.");
        // Nếu refresh thất bại (ví dụ: refreshToken cũng hết hạn), xóa hết token
        await clearTokens();
        return null;
      }
    }

    // Nếu token vẫn còn hạn, trả về token cũ
    return accessToken;
  }
}