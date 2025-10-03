import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> requestPasswordReset({required String email}) async {
    emit(ForgotPasswordLoading());
    // Giả lập cuộc gọi API để gửi email
    await Future.delayed(const Duration(seconds: 2));

    // Logic giả lập: kiểm tra xem email có tồn tại trong hệ thống không
    if (email == 'nonexistent@test.com') {
      emit(ForgotPasswordFailure(message: 'Email này không tồn tại trong hệ thống.'));
    } else {
      // Gửi yêu cầu thành công
      emit(ForgotPasswordSuccess(
          message: 'Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn.'));
    }
  }
}