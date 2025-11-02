import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'owner_login_state.dart';

class OwnerLoginCubit extends Cubit<OwnerLoginState> {
  OwnerLoginCubit() : super(OwnerLoginInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> login({required String email, required String password}) async {
    if (isClosed) return;
    emit(OwnerLoginLoading());
    try {
      final data = await _authRepository.login(
        email: email,
        password: password,
      );

      final user = data['user'] as Map<String, dynamic>;
      
      final String role = (user['role'] as String?)?.toLowerCase() ?? '';

      if (role == 'partner') {
        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;

        // SỬA LỖI: Sử dụng hàm saveTokens duy nhất để thông báo cho GoRouter
        await AuthService.saveTokens(accessToken, refreshToken);

        AppLogger.success('Đăng nhập Owner thành công qua API: ${user['email']}');
        if (isClosed) return;
        emit(OwnerLoginSuccess());
      } else {
        AppLogger.warning('Tài khoản ${user['email']} (role: ${user['role']}) không phải là Partner.');
        if (isClosed) return;
        emit(OwnerLoginFailure(message: 'Tài khoản này không phải là tài khoản Đối tác.'));
      }
      
    } on LoginException catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi đăng nhập Owner API: ${e.message}');
      emit(OwnerLoginFailure(message: e.message));
    } catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng nhập Owner: $e');
      emit(OwnerLoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
