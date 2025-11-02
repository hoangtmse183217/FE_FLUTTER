import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart'; // THÊM MỚI
import 'package:mumiappfood/features/profile/data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository; // THÊM MỚI

  ProfileCubit({ProfileRepository? profileRepository, AuthRepository? authRepository}) // THÊM MỚI
      : _profileRepository = profileRepository ?? ProfileRepository(),
        _authRepository = authRepository ?? AuthRepository(), // THÊM MỚI
        super(ProfileInitial());

  String _mapApiValueToGender(String? apiValue) {
    switch (apiValue?.toLowerCase()) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return 'Chưa cập nhật';
    }
  }

  Future<void> loadProfile() async {
    if (state is! ProfileLoaded) {
      emit(ProfileLoading());
    }
    try {
      final profileData = await _profileRepository.getMyProfile();
      final profileDetails = profileData['profile'] as Map<String, dynamic>?;

      emit(ProfileLoaded(
        userData: profileData,
        displayName: profileData['fullname'] ?? 'Người dùng',
        photoURL: profileDetails?['avatar'],
        phoneNumber: profileDetails?['phoneNumber'] ?? 'Chưa cập nhật',
        address: profileDetails?['address'] ?? 'Chưa cập nhật',
        gender: _mapApiValueToGender(profileDetails?['gender']),
      ));
    } catch (e, stackTrace) {
      AppLogger.error('Lỗi tải hồ sơ trong Cubit: $e', e, stackTrace);
      emit(ProfileError(message: 'Không thể tải hồ sơ người dùng. Vui lòng thử lại.'));
    }
  }

  void updateDisplayName(String newName) { if (state is ProfileLoaded) emit((state as ProfileLoaded).copyWith(displayName: newName)); }
  void updatePhoneNumber(String newPhone) { if (state is ProfileLoaded) emit((state as ProfileLoaded).copyWith(phoneNumber: newPhone)); }
  void updateAddress(String newAddress) { if (state is ProfileLoaded) emit((state as ProfileLoaded).copyWith(address: newAddress)); }
  void updateGender(String newGender) { if (state is ProfileLoaded) emit((state as ProfileLoaded).copyWith(gender: newGender)); }

  Future<void> uploadAndSaveAvatar(XFile imageFile) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(currentState.copyWith(newAvatarFile: () => imageFile));

    try {
      final newAvatarUrl = await _profileRepository.uploadAvatar(imageFile);
      emit(currentState.copyWith(
        photoURL: () => newAvatarUrl,
        newAvatarFile: () => null, 
      ));
    } catch (e) {
      emit(ProfileError(message: 'Tải ảnh lên thất bại: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> saveProfile() async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;
    emit(currentState.copyWith(isSaving: true));

    try {
      final Map<String, String> genderMap = {'Nam': 'Male', 'Nữ': 'Female', 'Khác': 'Other'};
      final Map<String, dynamic> dataToUpdate = {
        'fullname': currentState.displayName,
        if (currentState.phoneNumber.isNotEmpty && currentState.phoneNumber != 'Chưa cập nhật')
          'phoneNumber': currentState.phoneNumber,
        if (currentState.address.isNotEmpty && currentState.address != 'Chưa cập nhật')
          'address': currentState.address,
        if (currentState.gender.isNotEmpty && currentState.gender != 'Chưa cập nhật')
          'gender': genderMap[currentState.gender] ?? currentState.gender,
      };

      await _profileRepository.updateMyProfile(dataToUpdate);
      
      emit(ProfileSaveSuccess());

      await loadProfile();

    } catch (e) {
      emit(ProfileError(message: 'Lưu hồ sơ thất bại: ${e.toString()}'));
      emit(currentState.copyWith(isSaving: false));
    }
  }

  // THÊM MỚI: Phương thức logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(message: 'Đăng xuất thất bại: ${e.toString()}'));
    }
  }
}
