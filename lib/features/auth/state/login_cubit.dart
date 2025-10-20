import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/logger.dart';
import '../data/providers/auth_api_provider.dart';
import '../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final AuthRepository _authRepository = AuthRepository();

  /// --- HÀM HELPER ĐỂ XỬ LÝ KẾT QUẢ ĐĂNG NHẬP ---
  Future<void> _handleLoginSuccess(Map<String, dynamic> data) async {
    final user = data['user'] as Map<String, dynamic>;
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;

    await AuthService.saveAccessToken(accessToken);
    await AuthService.saveRefreshToken(refreshToken);

    AppLogger.success('Đăng nhập API thành công cho user: ${user['email']}');
    emit(LoginSuccess());
  }

  /// --- Xử lý logic đăng nhập bằng API riêng ---
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final data = await _authRepository.login(
        email: email,
        password: password,
      );
      // Gọi hàm helper
      await _handleLoginSuccess(data);

    } on LoginException catch (e) {
      AppLogger.error('Lỗi đăng nhập API: ${e.message}');
      emit(LoginFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng nhập: $e');
      emit(LoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }

  /// --- Xử lý logic đăng nhập bằng Google qua API riêng ---
  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final data = await _authRepository.loginWithGoogle();
      // Gọi hàm helper
      await _handleLoginSuccess(data);

    } on LoginException catch (e) {
      AppLogger.error('Lỗi đăng nhập Google API: ${e.message}');
      emit(LoginFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng nhập Google: $e');
      emit(LoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}