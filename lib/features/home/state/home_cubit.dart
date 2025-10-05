import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Tải thông tin người dùng đang đăng nhập
  void loadUserData() {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(HomeLoaded(user: currentUser));
    }
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    // Đăng xuất khỏi Google trước để đảm bảo sạch sẽ
    await GoogleSignIn().signOut();
    // Sau đó đăng xuất khỏi Firebase
    await _auth.signOut();
  }
}