import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'owner_register_state.dart';

class OwnerRegisterCubit extends Cubit<OwnerRegisterState> {
  OwnerRegisterCubit() : super(OwnerRegisterInitial());

  Future<void> register({
    required String restaurantName,
    required String email,
    required String password,
  }) async {
    emit(OwnerRegisterLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'existing.owner@test.com') {
      emit(OwnerRegisterFailure(message: 'Email này đã được đối tác khác sử dụng.'));
    } else {
      emit(OwnerRegisterSuccess());
    }
  }
}