import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/utils/logger.dart';

part 'owner_register_state.dart';

class OwnerRegisterCubit extends Cubit<OwnerRegisterState> {
  OwnerRegisterCubit() : super(OwnerRegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(OwnerRegisterLoading());

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) throw Exception("...");

      // Đảm bảo hành động này hoàn tất
      await user.updateDisplayName('[OWNER] ' + fullName);
      await _auth.signOut();
      AppLogger.success('Đăng ký tài khoản Owner thành công: ${user.email}');
      if (isClosed) return;
      emit(OwnerRegisterSuccess());

    } on FirebaseAuthException catch (e) {
      String message = 'Đã có lỗi xảy ra.';
      if (e.code == 'weak-password') message = 'Mật khẩu quá yếu.';
      if (e.code == 'email-already-in-use') message = 'Email này đã được sử dụng.';

      // 3. KIỂM TRA LẠI TRƯỚC KHI EMIT
      if (isClosed) return;
      emit(OwnerRegisterFailure(message: message));

    } catch (e) {
      AppLogger.error('Lỗi không xác định khi đăng ký Owner: $e');

      // 4. KIỂM TRA LẠI TRƯỚC KHI EMIT
      if (isClosed) return;
      emit(OwnerRegisterFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}