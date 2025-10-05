import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TODO: Khởi tạo Firebase Storage và Firestore ở đây
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 1. Tải dữ liệu người dùng ban đầu
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Người dùng chưa đăng nhập.');
      }

      // TODO: Tải dữ liệu bổ sung (SĐT, địa chỉ...) từ Firestore
      // final profileDoc = await _firestore.collection('profiles').doc(currentUser.uid).get();
      // final profileData = profileDoc.data();

      emit(ProfileLoaded(
        user: currentUser,
        displayName: currentUser.displayName ?? 'Người dùng',
        // Lấy dữ liệu từ Firestore hoặc dùng giá trị mặc định
        phoneNumber: /* profileData?['phoneNumber'] ?? */ 'Chưa cập nhật',
        address: /* profileData?['address'] ?? */ 'Chưa cập nhật',
        gender: /* profileData?['gender'] ?? */ 'Chưa cập nhật',
      ));
    } catch (e) {
      emit(ProfileError(message: 'Không thể tải hồ sơ người dùng.'));
    }
  }

  /// 2. Cập nhật tên hiển thị trong state (UI-only)
  void updateDisplayName(String newName) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      // Phát ra một state mới với tên đã được cập nhật
      emit(currentState.copyWith(displayName: newName));
    }
  }

  /// 3. Cập nhật file avatar mới trong state (UI-only)
  void updateAvatar(XFile newAvatar) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(newAvatarFile: newAvatar));
    }
  }

  // TODO: Tạo các hàm tương tự cho updatePhoneNumber, updateAddress...

  /// 4. Lưu tất cả thay đổi lên Firebase
  Future<void> saveProfile() async {
    if (state is! ProfileLoaded) return;

    final currentState = state as ProfileLoaded;
    emit(currentState.copyWith(isSaving: true)); // Báo cho UI biết đang lưu

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('Người dùng không hợp lệ.');

      // --- Logic Lưu ---

      // a. Cập nhật tên hiển thị trong FirebaseAuth
      if (currentUser.displayName != currentState.displayName) {
        await currentUser.updateDisplayName(currentState.displayName);
      }

      // b. Tải avatar mới lên Firebase Storage (nếu có)
      String? newPhotoURL;
      if (currentState.newAvatarFile != null) {
        // Đây là logic giả lập, bạn cần thay thế bằng code tải file thật
        // final ref = _storage.ref('avatars/${currentUser.uid}');
        // await ref.putFile(File(currentState.newAvatarFile!.path));
        // newPhotoURL = await ref.getDownloadURL();
        await Future.delayed(const Duration(seconds: 1)); // Giả lập tải lên
        newPhotoURL = 'https://via.placeholder.com/150'; // URL giả
      }

      // c. Cập nhật URL ảnh mới trong FirebaseAuth
      if (newPhotoURL != null && currentUser.photoURL != newPhotoURL) {
        await currentUser.updatePhotoURL(newPhotoURL);
      }

      // d. Lưu các thông tin còn lại vào Firestore
      // await _firestore.collection('profiles').doc(currentUser.uid).set({
      //   'phoneNumber': currentState.phoneNumber,
      //   'address': currentState.address,
      //   'gender': currentState.gender,
      //   'updated_at': FieldValue.serverTimestamp(),
      // }, SetOptions(merge: true));

      emit(ProfileSaveSuccess()); // Báo lưu thành công
      // Tải lại dữ liệu mới nhất sau khi lưu
      await loadProfile();

    } catch (e) {
      emit(ProfileError(message: 'Lưu hồ sơ thất bại. Vui lòng thử lại.'));
      // Quay lại trạng thái Loaded với isSaving = false
      emit(currentState.copyWith(isSaving: false));
    }
  }

  void updatePhoneNumber(String newPhoneNumber) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(phoneNumber: newPhoneNumber));
    }
  }

  void updateGender(String newGender) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(gender: newGender));
    }
  }
}