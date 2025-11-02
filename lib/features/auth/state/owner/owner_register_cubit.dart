import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'owner_register_state.dart';

class OwnerRegisterCubit extends Cubit<OwnerRegisterState> {
  OwnerRegisterCubit() : super(OwnerRegisterInitial());

  final AuthRepository _authRepository = AuthRepository();

  /// Hàm đăng ký Owner
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(OwnerRegisterLoading());
    try {
      // 1. Gọi hàm registerPartner từ Repository
      final data = await _authRepository.registerPartner(
        fullname: fullName,
        email: email,
        password: password,
      );

      final user = data['user'] as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String;
      
      // SỬA LỖI: Sử dụng hàm saveTokens duy nhất để thông báo cho GoRouter
      await AuthService.saveTokens(accessToken, refreshToken);

      AppLogger.success('Đăng ký và đăng nhập Owner thành công: ${user['email']}');
      
      if (isClosed) return;
      emit(OwnerRegisterSuccess());

    } on RegistrationException catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi đăng ký Owner API: ${e.message}');
      emit(OwnerRegisterFailure(message: e.message));
    } catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng ký Owner: $e');
      emit(OwnerRegisterFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
