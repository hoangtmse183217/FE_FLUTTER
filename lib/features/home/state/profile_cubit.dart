// lib/features/home/state/profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/profile/data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository = ProfileRepository();

  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profileData = await _profileRepository.getMyProfile();

      // --- LOGIC XỬ LÝ 'profile' AN TOÀN HƠN ---
      Map<String, dynamic>? profileDetails;
      // Kiểm tra xem 'profile' có tồn tại và có phải là một Map hay không
      if (profileData['profile'] is Map<String, dynamic>) {
        profileDetails = profileData['profile'] as Map<String, dynamic>;
      }

      emit(ProfileLoaded(
        userData: profileData,
        displayName: profileData['fullname'] ?? 'Người dùng',

        // Sử dụng profileDetails đã được kiểm tra an toàn
        photoURL: profileDetails?['avatar'],
        phoneNumber: profileDetails?['phoneNumber'] ?? 'Chưa cập nhật',
        address: profileDetails?['address'] ?? 'Chưa cập nhật',
        gender: profileDetails?['gender'] ?? 'Chưa cập nhật',
      ));

    } catch (e, stackTrace) { // Thêm stackTrace để debug
      AppLogger.error('Lỗi tải hồ sơ trong Cubit: $e', e, stackTrace);
      emit(ProfileError(message: 'Không thể tải hồ sơ người dùng. Vui lòng thử lại.'));
    }
  }

  // --- Các hàm update UI-only (giữ nguyên không đổi) ---
  void updateDisplayName(String newName) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(displayName: newName));
    }
  }

  void updateAvatar(XFile newAvatar) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(newAvatarFile: newAvatar));
    }
  }

  void updatePhoneNumber(String newPhone) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(phoneNumber: newPhone));
    }
  }

  void updateAddress(String newAddress) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(address: newAddress));
    }
  }

  void updateGender(String newGender) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(gender: newGender));
    }
  }

  Future<void> saveProfile() async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;
    emit(currentState.copyWith(isSaving: true));

    try {
      String? newAvatarUrl;
      // 1. NẾU CÓ ẢNH MỚI, TẢI LÊN TRƯỚC
      if (currentState.newAvatarFile != null) {
        AppLogger.info('Đang tải lên avatar mới...');
        newAvatarUrl = await _profileRepository.uploadAvatar(currentState.newAvatarFile!);
        AppLogger.success('Tải avatar thành công: $newAvatarUrl');
      }

      // 2. CHUẨN BỊ DỮ LIỆU VĂN BẢN (CHỈ GỬI CÁC TRƯỜNG CÓ DỮ LIỆU HỢP LỆ)
      final Map<String, dynamic> dataToUpdate = {
        'fullname': currentState.displayName,
      };

      // Chỉ thêm các trường nếu chúng có giá trị thật
      if (currentState.phoneNumber.isNotEmpty && currentState.phoneNumber != 'Chưa cập nhật') {
        dataToUpdate['phoneNumber'] = currentState.phoneNumber;
      }
      if (currentState.address.isNotEmpty && currentState.address != 'Chưa cập nhật') {
        dataToUpdate['address'] = currentState.address;
      }
      if (currentState.gender.isNotEmpty && currentState.gender != 'Chưa cập nhật') {
        // Giả sử API yêu cầu 'Male', 'Female', 'Other' (viết hoa chữ cái đầu)
        final apiGender = currentState.gender[0].toUpperCase() + currentState.gender.substring(1);
        dataToUpdate['gender'] = apiGender;
      }

      // Thêm URL avatar mới (nếu có) vào dữ liệu cần cập nhật
      if (newAvatarUrl != null) {
        dataToUpdate['avatar'] = newAvatarUrl;
      }

      // 3. GỌI API CẬP NHẬT PROFILE
      await _profileRepository.updateMyProfile(dataToUpdate);

      AppLogger.success('Lưu hồ sơ thành công.');
      emit(ProfileSaveSuccess());

      // Tải lại toàn bộ dữ liệu mới nhất từ server sau khi lưu
      emit(ProfileInitial()); // Reset state để loadProfile chạy lại
      await loadProfile();

    } catch (e) {
      AppLogger.error('Lỗi lưu hồ sơ: $e');
      emit(ProfileError(message: 'Lưu hồ-sơ-thất-bại: ${e.toString()}'));
      // Quay lại trạng thái Loaded với isSaving = false
      emit(currentState.copyWith(isSaving: false));
    }
  }
}