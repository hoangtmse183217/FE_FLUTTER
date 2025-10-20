import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:mumiappfood/routes/app_router.dart';

import '../widgets/profile/edit_address_dialog.dart';

// Lớp này chịu trách nhiệm cung cấp ProfileCubit
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Chúng ta không cần import Geolocator hay Geocoding ở đây nữa
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: const ProfileContent(),
    );
  }
}

// Lớp này chứa UI và các hàm xử lý sự kiện
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  // --- CÁC HÀM XỬ LÝ SỰ KIỆN ---

  /// Hiển thị trang chỉnh sửa địa chỉ
  Future<void> _showEditDisplayNameDialog(BuildContext context, String initialValue) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditDisplayNameDialog(initialValue: initialValue),
    );
    if (newName != null && newName.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateDisplayName(newName);
    }
  }

  /// Hiển thị trang chỉnh sửa số điện thoại
  Future<void> _showEditPhoneNumberDialog(BuildContext context, String initialValue) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditPhoneNumberDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newPhoneNumber != null && newPhoneNumber.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updatePhoneNumber(newPhoneNumber);
    }
  }
  /// Hiển thị trang chỉnh sửa địa chỉ
  Future<void> _showGenderSelectionSheet(BuildContext context, String initialValue) async {
    final newGender = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => GenderSelectionSheet(initialValue: initialValue),
    );
    if (newGender != null && newGender.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateGender(newGender);
    }
  }

  /// Hiển thị trang chỉnh sửa địa chỉ
  Future<void> _showEditAddressDialog(BuildContext context, String initialValue) async {
    final newAddress = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditAddressDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newAddress != null && newAddress.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateAddress(newAddress);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaveSuccess) {
          AppSnackbar.showSuccess(context, 'Đã lưu hồ sơ thành công!');
        } else if (state is ProfileError && state.message.isNotEmpty) {
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

        if (state is ProfileLoaded) {
          final loadedState = state;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Hồ sơ của tôi'),
              actions: [
                Padding(
                  // Thêm padding để tăng vùng nhấn và tạo khoảng cách
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextButton(
                    onPressed: loadedState.isSaving ? null : () => context.read<ProfileCubit>().saveProfile(),
                    // --- THÊM style VÀO ĐÂY ---
                    style: TextButton.styleFrom(
                      // Màu chữ khi nút có thể nhấn
                      foregroundColor: Theme.of(context).primaryColor,
                      // Màu chữ khi nút bị vô hiệu hóa (isSaving = true)
                      disabledForegroundColor: Colors.grey,
                    ),
                    child: loadedState.isSaving
                    // Hiển thị vòng xoay loading với màu chủ đạo
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        // Chỉ định màu cho vòng xoay
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                    // Hiển thị văn bản
                        : const Text(
                      'Lưu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Làm chữ đậm hơn
                        fontSize: 16,                // Tăng kích thước chữ một chút
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(kSpacingM),
              child: Column(
                children: [
                  ProfileAvatar(
                    photoURL: loadedState.photoURL,
                    fallbackText: loadedState.displayName.isNotEmpty ? loadedState.displayName.substring(0, 1).toUpperCase() : 'U',
                    onImageSelected: (XFile imageFile) => context.read<ProfileCubit>().updateAvatar(imageFile),
                  ),
                  vSpaceM,
                  Text(loadedState.displayName, style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                      loadedState.userData['email'] ?? 'Không có email',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
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
                          onTap: () => _showEditAddressDialog(context, loadedState.address),
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
                  BlocListener<HomeCubit, HomeState>(
                    listener: (context, homeState) {
                      if (homeState is HomeLogoutSuccess) {
                        context.goNamed(AppRouteNames.roleSelection);
                      } else if (homeState is HomeError) {
                        AppSnackbar.showError(context, homeState.message);
                      }
                    },
                    child: Card(
                      child: ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Đăng xuất',
                        onTap: () {
                          context.read<HomeCubit>().logout();
                        },
                        isEditable: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Trạng thái không xác định')));
      },
    );
  }
}