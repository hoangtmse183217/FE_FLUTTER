part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaveSuccess extends ProfileState {}

// THÊM MỚI: State cho việc logout thành công
class ProfileLogoutSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});
}

class ProfileLoaded extends ProfileState {
  // Dữ liệu gốc từ API
  final Map<String, dynamic> userData;

  // Dữ liệu hiển thị và có thể chỉnh sửa trên UI
  final String displayName;
  final String? photoURL;
  final String phoneNumber;
  final String address;
  final String gender;

  // Dữ liệu tạm thời cho các hành động của người dùng
  final XFile? newAvatarFile; // File ảnh mới người dùng chọn
  final bool isSaving; // Cờ báo hiệu đang lưu thông tin

  const ProfileLoaded({
    required this.userData,
    required this.displayName,
    this.photoURL,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    this.newAvatarFile,
    this.isSaving = false,
  });

  // Phương thức copyWith hoàn chỉnh để cập nhật state một cách an toàn
  ProfileLoaded copyWith({
    Map<String, dynamic>? userData,
    String? displayName,
    // Dùng _UNDEFINED_ để cho phép gán giá trị null
    ValueGetter<String?>? photoURL,
    String? phoneNumber,
    String? address,
    String? gender,
    ValueGetter<XFile?>? newAvatarFile,
    bool? isSaving,
  }) {
    return ProfileLoaded(
      userData: userData ?? this.userData,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL != null ? photoURL() : this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      newAvatarFile: newAvatarFile != null ? newAvatarFile() : this.newAvatarFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
