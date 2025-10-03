import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/logger.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required String fullName, // Mặc dù không dùng trực tiếp, ta vẫn cần nó
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      // 1. Tạo người dùng mới trong Firebase Authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. (Tùy chọn nhưng rất khuyến khích) Cập nhật tên hiển thị của người dùng
      await userCredential.user?.updateDisplayName(fullName);

      AppLogger.success('Đăng ký thành công cho email: ${userCredential.user?.email}');
      emit(RegisterSuccess());

    } on FirebaseAuthException catch (e) {
      // 3. Bắt các lỗi cụ thể từ Firebase
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ.';
      }
      AppLogger.error('Lỗi đăng ký Firebase: ${e.code}');
      emit(RegisterFailure(message: message));
    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng ký: $e');
      emit(RegisterFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}