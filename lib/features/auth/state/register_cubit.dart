import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/utils/logger.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Thêm biện pháp phòng vệ
    if (isClosed) return;
    emit(RegisterLoading());

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) throw Exception("Không thể tạo người dùng.");

      await user.updateDisplayName(fullName);

      // --- THAY ĐỔI QUAN TRỌNG Ở ĐÂY ---
      // Đăng xuất ngay sau khi tạo tài khoản để ngăn redirect tự động
      await _auth.signOut();

      AppLogger.success('Đã tạo tài khoản User thành công: ${user.email}. Vui lòng đăng nhập.');

      if (isClosed) return;
      emit(RegisterSuccess());

    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      if (e.code == 'weak-password') message = 'Mật khẩu quá yếu.';
      if (e.code == 'email-already-in-use') message = 'Email này đã được sử dụng.';
      if (e.code == 'invalid-email') message = 'Email không hợp lệ.';
      emit(RegisterFailure(message: message));
    } catch (e) {
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng ký User: $e');
      emit(RegisterFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}