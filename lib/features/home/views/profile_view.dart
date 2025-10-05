import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

import 'package:mumiappfood/features/home/widgets/profile/edit_display_name_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_avatar.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';

import '../state/home_cubit.dart';
import '../state/profile_cubit.dart';
import '../widgets/profile/edit_phone_number_dialog.dart';
import '../widgets/profile/gender_selection_sheet.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp ProfileCubit cho cây widget con
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: const ProfileContent(),
    );
  }
}

// ProfileContent giờ là một StatelessWidget, không còn quản lý state nữa
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  // TẠO HÀM MỚI ĐỂ MỞ DIALOG TÊN HIỂN THỊ
  Future<void> _showEditDisplayNameDialog(BuildContext context, String initialValue) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return EditDisplayNameDialog(initialValue: initialValue);
      },
    );

    // Nếu có tên mới trả về, gọi Cubit để cập nhật state
    if (newName != null && newName.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateDisplayName(newName);
    }
  }
  // TẠO HÀM MỚI ĐỂ MỞ DIALOG SỐ ĐIỆN THOẠI
  Future<void> _showEditPhoneNumberDialog(BuildContext context, String initialValue) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,

      builder: (dialogContext) {
        return EditPhoneNumberDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue);
      },
    );

    if (newPhoneNumber != null && newPhoneNumber.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updatePhoneNumber(newPhoneNumber);
    }
  }
  // TẠO HÀM MỚI ĐỂ MỞ BOTTOM SHEET GIỚI TÍNH
  Future<void> _showGenderSelectionSheet(BuildContext context, String initialValue) async {
    final newGender = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return GenderSelectionSheet(initialValue: initialValue);
      },
    );

    if (newGender != null && newGender.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateGender(newGender);
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocConsumer lắng nghe các sự kiện (ví dụ: lưu thành công) và build lại UI
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: Xử lý các sự kiện phụ như hiển thị SnackBar
        // if (state is ProfileSaveSuccess) { ... }
        // if (state is ProfileSaveFailure) { ... }
      },
      builder: (context, state) {
        // Xử lý các trạng thái Loading và Error
        if (state is ProfileLoading || state is ProfileInitial) {
          return Scaffold(
            appBar: AppBar(title: const Text('Hồ sơ của tôi')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Hồ sơ của tôi')),
            body: Center(child: Text(state.message)),
          );
        }

        // Khi đã tải xong, làm việc với ProfileLoaded state
        final loadedState = state as ProfileLoaded;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ của tôi'),
            actions: [
              TextButton(
                onPressed: () {
                  // Gọi hàm lưu từ Cubit
                  context.read<ProfileCubit>().saveProfile();
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(kSpacingM),
            child: Column(
              children: [
                ProfileAvatar(
                  photoURL: loadedState.user.photoURL,
                  fallbackText: loadedState.displayName.isNotEmpty
                      ? loadedState.displayName.substring(0, 1)
                      : 'U',
                  onImageSelected: (XFile imageFile) {
                    // Gọi hàm trong Cubit để cập nhật state
                    context.read<ProfileCubit>().updateAvatar(imageFile);
                  },
                ),
                vSpaceM,
                Text(
                  loadedState.displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                    loadedState.user.email ?? 'Không có email',
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
                        onTap: () { /* TODO: Mở dialog sửa địa chỉ */ },
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
                    onTap: () {
                      // Vẫn có thể truy cập HomeCubit vì nó nằm trong context
                      context.read<HomeCubit>().logout();
                    },
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