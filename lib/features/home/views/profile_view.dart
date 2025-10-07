import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/state/profile_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_display_name_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_phone_number_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/gender_selection_sheet.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_avatar.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';

// Lớp này chịu trách nhiệm cung cấp ProfileCubit
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: const ProfileContent(),
    );
  }
}

// Lớp này chứa toàn bộ UI và các hàm xử lý sự kiện
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

// Hiển thị hộp thoại chỉnh sửa tên hiển thị
  Future<void> _showEditDisplayNameDialog(BuildContext context, String initialValue) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditDisplayNameDialog(initialValue: initialValue),
    );
    if (newName != null && newName.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateDisplayName(newName);
    }
  }
// Hiển thị hộp thoại chỉnh sửa số điện thoại
  Future<void> _showEditPhoneNumberDialog(BuildContext context, String initialValue) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditPhoneNumberDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newPhoneNumber != null && newPhoneNumber.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updatePhoneNumber(newPhoneNumber);
    }
  }
// Hiển thị bottom sheet chọn giới tính
  Future<void> _showGenderSelectionSheet(BuildContext context, String initialValue) async {
    final newGender = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => GenderSelectionSheet(initialValue: initialValue),
    );
    if (newGender != null && newGender.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateGender(newGender);
    }
  }
// Cập nhật địa chỉ từ GPS
  Future<void> _updateAddressFromGPS(BuildContext context) async {
    AppSnackbar.showInfo(context, 'Đang lấy vị trí hiện tại...');
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Vui lòng bật dịch vụ định vị.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Quyền truy cập vị trí đã bị từ chối.');
      }
      if (permission == LocationPermission.deniedForever) throw Exception('Bạn cần cấp quyền vị trí trong cài đặt.');

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (!context.mounted) return;


      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final addressComponents = [place.street, place.subLocality, place.subAdministrativeArea, place.administrativeArea];
        final fullAddress = addressComponents.where((c) => c != null && c.isNotEmpty).join(', ');

        context.read<ProfileCubit>().updateAddress(fullAddress);
        AppSnackbar.showSuccess(context, 'Đã cập nhật địa chỉ.');
      } else {
        throw Exception('Không thể xác định địa chỉ.');
      }
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e.toString());
    }
  }
// Xây dựng giao diện người dùng dựa trên trạng thái của ProfileCubit
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaveSuccess) {
          AppSnackbar.showSuccess(context, 'Đã lưu hồ sơ thành công!');
        }
        if (state is ProfileError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return Scaffold(appBar: AppBar(title: const Text('Hồ sơ của tôi')), body: const Center(child: CircularProgressIndicator()));
        }

        if (state is ProfileError) {
          return Scaffold(appBar: AppBar(title: const Text('Hồ sơ của tôi')), body: Center(child: Text(state.message)));
        }

        final loadedState = state as ProfileLoaded;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ của tôi'),
            actions: [
              TextButton(
                onPressed: loadedState.isSaving ? null : () => context.read<ProfileCubit>().saveProfile(),
                child: loadedState.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Lưu'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(kSpacingM),
            child: Column(
              children: [
                ProfileAvatar(
                  photoURL: loadedState.user.photoURL,
                  fallbackText: loadedState.displayName.isNotEmpty ? loadedState.displayName.substring(0, 1) : 'U',
                  onImageSelected: (XFile imageFile) => context.read<ProfileCubit>().updateAvatar(imageFile),
                ),
                vSpaceM,
                Text(loadedState.displayName, style: Theme.of(context).textTheme.headlineSmall),
                Text(loadedState.user.email ?? 'Không có email', style: Theme.of(context).textTheme.bodyMedium),
                vSpaceXL,
                Card(
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Tên hiển thị',
                        value: loadedState.displayName,
                        onTap: () => _showEditDisplayNameDialog(context, loadedState.displayName),
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.phone_outlined,
                        title: 'Số điện thoại',
                        value: loadedState.phoneNumber,
                        onTap: () => _showEditPhoneNumberDialog(context, loadedState.phoneNumber),
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Địa chỉ',
                        value: loadedState.address,
                        onTap: () => _updateAddressFromGPS(context),
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.transgender_outlined,
                        title: 'Giới tính',
                        value: loadedState.gender,
                        onTap: () => _showGenderSelectionSheet(context, loadedState.gender),
                      ),
                    ],
                  ),
                ),
                vSpaceL,
                Card(
                  child: ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () => context.read<HomeCubit>().logout(),
                    isEditable: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}