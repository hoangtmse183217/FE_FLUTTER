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
    // SỬA LỖI: Gọi API logout trước khi xóa token local
    final accessToken = await AuthService.getAccessToken();
    try {
      if (accessToken != null) {
        // Gọi API để vô hiệu hóa token trên server.
        // Không cần await vì chúng ta muốn logout ở client ngay cả khi mạng lỗi.
        _apiProvider.logoutUser(accessToken: accessToken);
      }
    } catch (e) {
      // Bỏ qua lỗi khi gọi API logout, nhưng ghi lại để debug
      print('Error during API logout, proceeding with client-side logout: $e');
    } finally {
      // Luôn đảm bảo rằng token ở client được xóa và đăng xuất khỏi Google.
      await _googleSignIn.signOut();
      await AuthService.clearTokens();
    }
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

  /// Đăng ký đối tác
  Future<Map<String, dynamic>> registerPartner({
    required String fullname,
    required String email,
    required String password,
  }) {
    return _apiProvider.registerPartner(
      fullname: fullname,
      email: email,
      password: password,
    );
  }

  /// Đổi mật khẩu
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _apiProvider.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
