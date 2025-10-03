import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    // Giả lập cuộc gọi API
    await Future.delayed(const Duration(seconds: 2));

    // Logic nghiệp vụ giả lập: kiểm tra xem email đã tồn tại chưa
    if (email == 'existing@test.com') {
      emit(RegisterFailure(message: 'Email này đã được sử dụng.'));
    } else {
      // Đăng ký thành công
      emit(RegisterSuccess());
    }
  }
}