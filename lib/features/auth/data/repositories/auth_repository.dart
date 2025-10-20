import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/auth_service.dart';
import '../providers/auth_api_provider.dart';

class AuthRepository {
  /// Provider để gọi API
  final _apiProvider = AuthApiProvider();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Đăng ký người dùng
  Future<void> register({
    required String fullname,
    required String email,
    required String password,
  }) {
    return _apiProvider.registerUser(
      fullname: fullname,
      email: email,
      password: password,
    );
  }

  /// Đăng nhập người dùng
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _apiProvider.loginUser(email: email, password: password);
  }

  /// Đăng nhập người dùng bằng Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    // 1. Bắt đầu quá trình đăng nhập Google ở client
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // Người dùng đã hủy
      throw LoginException('Quá trình đăng nhập Google đã bị hủy.');
    }

    // 2. Lấy idToken
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw LoginException('Không thể lấy được token từ Google.');
    }

    // 3. Gửi idToken đến backend
    return _apiProvider.loginWithGoogleToken(idToken: idToken);
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    await AuthService.clearTokens();
  }

  /// Yêu cầu đặt lại mật khẩu
  Future<String> requestPasswordReset({required String email}) {
    return _apiProvider.requestPasswordReset(email: email);
  }

  /// Đặt lại mật khẩu
  Future<void> resetPassword({
    required String email,
    required String token,
    required String otp,
    required String newPassword,
  }) {
    return _apiProvider.resetPassword(email: email, token: token, otp: otp, newPassword: newPassword);
  }

}