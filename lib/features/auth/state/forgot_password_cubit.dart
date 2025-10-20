import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());
  final AuthRepository _authRepository = AuthRepository();

  Future<void> requestPasswordReset({required String email}) async {
    emit(ForgotPasswordLoading());
    try {
      // Nhận token từ repository
      final String token = await _authRepository.requestPasswordReset(email: email);
      emit(ForgotPasswordSuccess(
        message: 'OTP đã được gửi đến email của bạn.',
        resetToken: token, // <-- Lưu token vào state
      ));
    } on ForgotPasswordException catch (e) {
      emit(ForgotPasswordFailure(message: e.message));
    } catch (e) {
      emit(ForgotPasswordFailure(message: 'Đã có lỗi xảy ra.'));
    }
  }
}