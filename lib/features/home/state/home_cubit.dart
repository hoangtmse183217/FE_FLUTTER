import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final AuthRepository _authRepository = AuthRepository();

  /// Đăng xuất người dùng
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      AppLogger.success('User logged out successfully.');
      // Phát ra state thành công để UI có thể lắng nghe
      emit(HomeLogoutSuccess());
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      // Phát ra state lỗi
      emit(HomeError('Đăng xuất thất bại. Vui lòng thử lại.'));
    }
  }
}