import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/auth/data/providers/auth_api_provider.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  final AuthRepository _authRepository = AuthRepository();

  Future<void> resetPassword({
    required String email,
    required String token,
    required String otp,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _authRepository.resetPassword(email: email,token: token, otp: otp, newPassword: newPassword);
      emit(ResetPasswordSuccess());
    } on ResetPasswordException catch (e) {
      emit(ResetPasswordFailure(message: e.message));
    } catch (e) {
      emit(ResetPasswordFailure(message: 'Đã có lỗi xảy ra.'));
    }
  }
}