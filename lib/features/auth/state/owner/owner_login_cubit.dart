import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'owner_login_state.dart';

class OwnerLoginCubit extends Cubit<OwnerLoginState> {
  OwnerLoginCubit() : super(OwnerLoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(OwnerLoginLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'owner@test.com' && password == 'password') {
      emit(OwnerLoginSuccess());
    } else {
      emit(OwnerLoginFailure(message: 'Tài khoản đối tác không hợp lệ.'));
    }
  }
}