import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/logger.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> requestPasswordReset({required String email}) async {
    emit(ForgotPasswordLoading());
    try {
      // 1. Gửi email đặt lại mật khẩu
      await _auth.sendPasswordResetEmail(email: email);

      AppLogger.success('Yêu cầu đặt lại mật khẩu đã được gửi đến: $email');
      emit(ForgotPasswordSuccess(
          message: 'Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn.'));

    } on FirebaseAuthException catch (e) {
      // 2. Bắt các lỗi cụ thể từ Firebase
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      if (e.code == 'invalid-email' || e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = 'Email không hợp lệ hoặc không tồn tại trong hệ thống.';
      }

      AppLogger.error('Lỗi gửi email đặt lại MK: ${e.code}');
      emit(ForgotPasswordFailure(message: message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đặt lại MK: $e');
      emit(ForgotPasswordFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}