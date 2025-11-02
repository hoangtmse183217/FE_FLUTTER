import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart'; // THÊM MỚI
import 'package:mumiappfood/features/profile/data/repositories/profile_repository.dart';

part 'owner_profile_state.dart';

class OwnerProfileCubit extends Cubit<OwnerProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository; // THÊM MỚI

  OwnerProfileCubit({ProfileRepository? profileRepository, AuthRepository? authRepository}) // THÊM MỚI
      : _profileRepository = profileRepository ?? ProfileRepository(),
        _authRepository = authRepository ?? AuthRepository(), // THÊM MỚI
        super(OwnerProfileInitial());

  // --- HÀM HELPER XỬ LÝ GIỚI TÍNH ---
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
    emit(OwnerProfileLoading());
    try {
      final userData = await _profileRepository.getMyProfile();
      final profileDetails = userData['profile'] as Map<String, dynamic>?;

      emit(ProfileLoaded(
        userData: userData,
        displayName: userData['fullname'] ?? 'Đối tác',
        photoURL: profileDetails?['avatar'],
        phoneNumber: profileDetails?['phoneNumber'] ?? 'Chưa cập nhật',
        address: profileDetails?['address'] ?? 'Chưa cập nhật',
        gender: _mapApiValueToGender(profileDetails?['gender']),
      ));
    } catch (e) {
      emit(ProfileError(message: 'Không thể tải hồ sơ: ${e.toString()}'));
    }
  }

  // --- CÁC HÀM UPDATE STATE TRÊN UI ---
  void updateDisplayName(String newName) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(displayName: newName));
    }
  }

  void updatePhoneNumber(String newPhoneNumber) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(phoneNumber: newPhoneNumber));
    }
  }

  void updateAddress(String newAddress) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(address: newAddress));
    }
  }

  void updateGender(String newGender) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(gender: newGender));
    }
  }

  Future<void> uploadAndSaveAvatar(XFile imageFile) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isSaving: true));
      try {
        final downloadUrl = await _profileRepository.uploadAvatar(imageFile);
        // API uploadAvatar đã tự lưu vào DB, chỉ cần cập nhật UI
        emit(currentState.copyWith(photoURL: downloadUrl, isSaving: false));
        emit(ProfileSaveSuccess());
        // Tải lại để đồng bộ, hoặc có thể chỉ cần cập nhật state cục bộ
        await loadProfile(); 
      } catch (e) {
        emit(ProfileError(message: 'Tải ảnh lên thất bại: ${e.toString()}'));
        emit(currentState.copyWith(isSaving: false)); // Quay lại trạng thái cũ
      }
    }
  }

  Future<void> saveProfile() async {
    if (state is ProfileLoaded) {
      final loadedState = state as ProfileLoaded;
      emit(loadedState.copyWith(isSaving: true));

      try {
        final Map<String, dynamic> dataToUpdate = {
          'fullname': loadedState.displayName,
        };

        if (loadedState.phoneNumber.isNotEmpty && loadedState.phoneNumber != 'Chưa cập nhật') {
          dataToUpdate['phoneNumber'] = loadedState.phoneNumber;
        }
        if (loadedState.address.isNotEmpty && loadedState.address != 'Chưa cập nhật') {
          dataToUpdate['address'] = loadedState.address;
        }
        if (loadedState.gender.isNotEmpty && loadedState.gender != 'Chưa cập nhật') {
           final gender = loadedState.gender.trim();
           final apiGender = gender[0].toUpperCase() + gender.substring(1).toLowerCase();
           dataToUpdate['gender'] = apiGender;
        }

        await _profileRepository.updateMyProfile(dataToUpdate);
        
        emit(ProfileSaveSuccess());
        // Tải lại toàn bộ hồ sơ để đảm bảo dữ liệu là mới nhất
        await loadProfile();

      } catch (e) {
        emit(ProfileError(message: 'Lưu hồ sơ thất bại: ${e.toString()}'));
        emit(loadedState.copyWith(isSaving: false)); // Quay lại trạng thái cũ
      }
    }
  }

  // THÊM MỚI: Phương thức logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(OwnerProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(message: 'Đăng xuất thất bại: ${e.toString()}'));
    }
  }
}
