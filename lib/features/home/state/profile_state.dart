// lib/features/home/state/profile_state.dart

part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  // --- THAY ĐỔI Ở ĐÂY ---
  // 1. Thay thế 'User user' bằng 'Map<String, dynamic> userData'
  // userData sẽ chứa thông tin được giải mã từ JWT token.
  final Map<String, dynamic> userData;

  // 2. Thêm trường 'photoURL' để lưu trữ URL avatar
  final String? photoURL;

  // Dữ liệu người dùng đang chỉnh sửa, sẽ được hiển thị trên UI
  final String displayName;
  final String phoneNumber;
  final String address;
  final String gender;
  final XFile? newAvatarFile; // File ảnh mới người dùng đã chọn

  // Cờ trạng thái để quản lý UI
  final bool isSaving;

  ProfileLoaded({
    required this.userData,
    this.photoURL,
    required this.displayName,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    this.newAvatarFile,
    this.isSaving = false,
  });

  // Hàm copyWith để tạo ra state mới mà không thay đổi state cũ
  ProfileLoaded copyWith({
    String? photoURL,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? gender,
    XFile? newAvatarFile,
    bool? isSaving,
  }) {
    return ProfileLoaded(
      userData: userData, // Dữ liệu gốc từ token không thay đổi
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      newAvatarFile: newAvatarFile ?? this.newAvatarFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfileSaveSuccess extends ProfileState {}