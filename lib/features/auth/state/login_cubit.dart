import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mumiappfood/core/utils/logger.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Xử lý logic đăng nhập bằng Email/Password với Firebase và kiểm tra vai trò
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Đăng nhập thất bại.');

      // --- SỬA LẠI: KIỂM TRA VAI TRÒ TỪ DISPLAYNAME ---
      if (user.displayName == null || !user.displayName!.startsWith('[OWNER]')) {
        AppLogger.success('Đăng nhập User thành công: ${user.email}');
        emit(LoginSuccess());
      } else {
        await _auth.signOut();
        AppLogger.warning('Tài khoản ${user.email} là Owner, không thể đăng nhập.');
        emit(LoginFailure(message: 'Tài khoản này không phải là tài khoản người dùng.'));
      }

    } on FirebaseAuthException catch (e) {
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

  /// Xử lý logic đăng nhập bằng Google và kiểm tra/tạo vai trò
  Future<void> loginWithGoogle() async {
    // Logic này vốn đã không dùng Firestore nên có thể giữ nguyên
    emit(LoginLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(LoginInitial());
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      // Đăng nhập Google mặc định là User, không cần kiểm tra vai trò
      emit(LoginSuccess());

    } catch (error, stackTrace) {
      AppLogger.error('Lỗi đăng nhập Google', error, stackTrace);
      emit(LoginFailure(message: 'Đã có lỗi xảy ra khi đăng nhập Google.'));
    }
  }
}