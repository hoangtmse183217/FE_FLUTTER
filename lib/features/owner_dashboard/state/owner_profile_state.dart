part of 'owner_profile_cubit.dart';

@immutable
abstract class OwnerProfileState {}

class OwnerProfileInitial extends OwnerProfileState {}
class OwnerProfileLoading extends OwnerProfileState {}

// THÊM MỚI: State cho việc logout thành công
class OwnerProfileLogoutSuccess extends OwnerProfileState {}

class ProfileLoaded extends OwnerProfileState {
  final Map<String, dynamic> userData;
  final String? photoURL;

  final String displayName;
  final String phoneNumber;
  final String address;
  final String gender;
  final XFile? newAvatarFile;

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
      userData: userData,
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

class ProfileError extends OwnerProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfileSaveSuccess extends OwnerProfileState {}
