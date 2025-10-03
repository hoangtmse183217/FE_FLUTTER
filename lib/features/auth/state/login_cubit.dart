// lib/features/auth/state/login_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mumiappfood/core/utils/logger.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Xử lý logic đăng nhập bằng Email/Password với Firebase
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      // Bắt các lỗi cụ thể từ Firebase
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Email hoặc mật khẩu không đúng.';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ.';
      }
      AppLogger.error('Lỗi đăng nhập Firebase: ${e.code}');
      emit(LoginFailure(message: message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng nhập: $e');
      emit(LoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }

  /// Xử lý logic đăng nhập bằng Google
  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      // 1. Bắt đầu quá trình đăng nhập Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(LoginInitial()); // Người dùng hủy
        return;
      }

      // 2. Lấy thông tin xác thực từ tài khoản Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Đăng nhập vào Firebase bằng thông tin xác thực đó
      await _auth.signInWithCredential(credential);

      AppLogger.success('Đăng nhập Google thành công: ${googleUser.email}');
      emit(LoginSuccess());

    } catch (error, stackTrace) {
      AppLogger.error('Lỗi đăng nhập Google', error, stackTrace);
      emit(LoginFailure(message: 'Đã có lỗi xảy ra khi đăng nhập Google.'));
    }
  }
}