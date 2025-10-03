import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  /// Bắt đầu quá trình khởi tạo của ứng dụng
  Future<void> initializeApp() async {
    // Đợi 2.5 giây để hiển thị logo, tạo cảm giác ứng dụng đang tải
    await Future.delayed(const Duration(milliseconds: 2500));

    // ====================================================================
    // NƠI ĐỂ THỰC HIỆN LOGIC KHỞI TẠO CỦA BẠN
    // Ví dụ: kiểm tra token, tải cấu hình từ server, v.v.
    // ====================================================================
    bool isLoggedIn = await _checkAuthenticationStatus();

    if (isLoggedIn) {
      // Nếu đã đăng nhập, điều hướng đến trang chủ
      emit(SplashLoaded(destinationRoute: '/')); // '/' là HomePage
    } else {
      // Nếu chưa, điều hướng đến trang đăng nhập
      emit(SplashLoaded(destinationRoute: '/login'));
    }
  }

  /// Hàm giả lập việc kiểm tra trạng thái đăng nhập của người dùng.
  /// Thay thế hàm này bằng logic thực tế của bạn.
  Future<bool> _checkAuthenticationStatus() async {
    // Ví dụ: Đọc token từ SharedPreferences hoặc Secure Storage
    // Ở đây chúng ta giả lập là người dùng đã đăng nhập.
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }
}