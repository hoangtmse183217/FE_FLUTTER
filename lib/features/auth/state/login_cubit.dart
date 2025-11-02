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

  /// --- Xử lý logic đăng nhập bằng API riêng ---
  Future<void> login({required String email, required String password}) async {
    if (isClosed) return;
    emit(LoginLoading());
    try {
      final data = await _authRepository.login(
        email: email,
        password: password,
      );
      
      final user = data['user'] as Map<String, dynamic>;
      final String role = (user['role'] as String?)?.toLowerCase() ?? 'user';

      if (role == 'user') {
        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;

        // SỬA LỖI: Sử dụng hàm saveTokens duy nhất để thông báo cho GoRouter
        await AuthService.saveTokens(accessToken, refreshToken);

        AppLogger.success('Đăng nhập User thành công qua API: ${user['email']}');
        if (isClosed) return;
        emit(LoginSuccess());
      } else {
        AppLogger.warning('Tài khoản ${user['email']} (role: ${user['role']}) không phải là User.');
        if (isClosed) return;
        emit(LoginFailure(message: 'Tài khoản này là tài khoản Đối tác. Vui lòng đăng nhập ở trang dành cho Đối tác.'));
      }

    } on LoginException catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi đăng nhập API: ${e.message}');
      emit(LoginFailure(message: e.message));
    } catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng nhập: $e');
      emit(LoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }

  /// --- Xử lý logic đăng nhập bằng Google qua API riêng ---
  Future<void> loginWithGoogle() async {
    if (isClosed) return;
    emit(LoginLoading());
    try {
      final data = await _authRepository.loginWithGoogle();
      
      final user = data['user'] as Map<String, dynamic>;
      final String role = (user['role'] as String?)?.toLowerCase() ?? 'user';

      if (role == 'user') {
        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;

        // SỬA LỖI: Sử dụng hàm saveTokens duy nhất để thông báo cho GoRouter
        await AuthService.saveTokens(accessToken, refreshToken);

        AppLogger.success('Đăng nhập User Google thành công qua API: ${user['email']}');
        if (isClosed) return;
        emit(LoginSuccess());
      } else {
        AppLogger.warning('Tài khoản Google ${user['email']} (role: ${user['role']}) không phải là User.');
        if (isClosed) return;
        emit(LoginFailure(message: 'Tài khoản này là tài khoản Đối tác. Vui lòng đăng nhập ở trang dành cho Đối tác.'));
      }

    } on LoginException catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi đăng nhập Google API: ${e.message}');
      emit(LoginFailure(message: e.message));
    } catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng nhập Google: $e');
      emit(LoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
