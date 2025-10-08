import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/utils/logger.dart';

part 'owner_login_state.dart';

class OwnerLoginCubit extends Cubit<OwnerLoginState> {
  OwnerLoginCubit() : super(OwnerLoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    emit(OwnerLoginLoading());
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) throw Exception('Đăng nhập thất bại.');

      // --- THAY ĐỔI Ở ĐÂY ---
      // Kiểm tra vai trò từ displayName
      if (user.displayName != null && user.displayName!.startsWith('[OWNER]')) {
        AppLogger.success('Đăng nhập Owner thành công: ${user.email}');
        emit(OwnerLoginSuccess());
      } else {
        await _auth.signOut();
        AppLogger.warning('Tài khoản ${user.email} không phải là Owner.');
        emit(OwnerLoginFailure(message: 'Tài khoản này không phải là tài khoản Đối tác.'));
      }

    } on FirebaseAuthException catch (e) {
      String message = 'Đã có lỗi xảy ra.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Email hoặc mật khẩu không đúng.';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ.';
      }
      AppLogger.error('Lỗi đăng nhập Owner Firebase: ${e.code}');
      emit(OwnerLoginFailure(message: message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng nhập Owner: $e');
      emit(OwnerLoginFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}