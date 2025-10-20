import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart'; // Import lớp Exception
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  // 1. Khởi tạo Repository thay vì FirebaseAuth
  final AuthRepository _authRepository = AuthRepository();

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(RegisterLoading());

    try {
      // 2. Gọi hàm register từ Repository
      await _authRepository.register(
        fullname: fullName,
        email: email,
        password: password,
      );

      AppLogger.success('Yêu cầu đăng ký tài khoản User thành công cho: $email');

      if (isClosed) return;
      // 3. Emit Success. Logic đăng xuất không còn cần thiết vì API không tự động đăng nhập.
      emit(RegisterSuccess());

    } on RegistrationException catch (e) {
      // 4. Bắt lỗi RegistrationException cụ thể từ ApiProvider
      if (isClosed) return;
      AppLogger.error('Lỗi đăng ký API: ${e.message}');
      emit(RegisterFailure(message: e.message));
    } catch (e) {
      // Bắt các lỗi không mong muốn khác
      if (isClosed) return;
      AppLogger.error('Lỗi không xác định khi đăng ký User: $e');
      emit(RegisterFailure(message: 'Đã có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}