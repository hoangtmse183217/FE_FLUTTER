// lib/features/auth/state/login_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mumiappfood/core/utils/logger.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  /// Xử lý logic đăng nhập bằng Email/Password
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@test.com' && password == 'password') {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(message: 'Email hoặc mật khẩu không đúng.'));
    }
  }

  /// Xử lý logic đăng nhập bằng Google
  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.standard(
        scopes: ['email'],
      );

      // Đăng xuất để hộp thoại chọn tài khoản luôn hiện ra
      await googleSignIn.signOut();

      // Bắt đầu quá trình đăng nhập
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(LoginInitial());
        return;
      }

      AppLogger.success('Đăng nhập Google thành công: ${googleUser.email}');
      await Future.delayed(const Duration(seconds: 1));
      emit(LoginSuccess());
    } catch (error, stackTrace) {
      AppLogger.error('Lỗi đăng nhập Google', error, stackTrace);
      emit(LoginFailure(message: 'Đã có lỗi xảy ra khi đăng nhập Google.'));
    }
  }
}