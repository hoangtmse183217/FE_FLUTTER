part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

// Trạng thái ban đầu, khi đang tải dữ liệu
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

// Trạng thái khi đã tải dữ liệu thành công
class ProfileLoaded extends ProfileState {
  // Dữ liệu gốc từ Firebase để so sánh
  final User user;

  // Dữ liệu người dùng đang chỉnh sửa, sẽ được hiển thị trên UI
  final String displayName;
  final String phoneNumber;
  final String address;
  final String gender;
  final XFile? newAvatarFile; // File ảnh mới người dùng đã chọn

  // Cờ trạng thái để quản lý UI
  final bool isSaving; // Cho biết có đang trong quá trình lưu hay không

  ProfileLoaded({
    required this.user,
    required this.displayName,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    this.newAvatarFile,
    this.isSaving = false,
  });

  // Hàm copyWith cực kỳ quan trọng để tạo ra state mới mà không thay đổi state cũ
  ProfileLoaded copyWith({
    String? displayName,
    String? phoneNumber,
    String? address,
    String? gender,
    XFile? newAvatarFile,
    bool? isSaving,
  }) {
    return ProfileLoaded(
      user: user, // user gốc không thay đổi
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      newAvatarFile: newAvatarFile ?? this.newAvatarFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// Trạng thái khi có lỗi xảy ra (tải hoặc lưu)
class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

// Trạng thái đặc biệt để báo cho UI biết rằng đã lưu thành công
class ProfileSaveSuccess extends ProfileState {}