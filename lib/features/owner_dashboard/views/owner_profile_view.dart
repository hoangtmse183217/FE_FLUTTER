import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_profile_cubit.dart';
// Import các dialog/sheet cần thiết
import 'package:mumiappfood/features/home/widgets/profile/change_password_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_address_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_display_name_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_phone_number_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/gender_selection_sheet.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_avatar.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerProfileView extends StatelessWidget {
  const OwnerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerProfileCubit()..loadProfile(),
      child: const OwnerProfileContent(),
    );
  }
}

class OwnerProfileContent extends StatelessWidget {
  const OwnerProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerProfileCubit, OwnerProfileState>(
      listener: (context, state) {
        if (state is ProfileSaveSuccess) {
          AppSnackbar.showSuccess(context, 'Đã cập nhật hồ sơ thành công!');
        } else if (state is ProfileError && state.message.isNotEmpty) {
          AppSnackbar.showError(context, state.message);
        } else if (state is OwnerProfileLogoutSuccess) { // SỬA ĐỔI: Lắng nghe OwnerProfileLogoutSuccess
          context.goNamed(AppRouteNames.roleSelection);
        }
      },
      builder: (context, state) {
        if (state is OwnerProfileInitial || state is OwnerProfileLoading) {
          return Scaffold(appBar: AppBar(title: const Text('Hồ sơ của bạn')), body: const Center(child: CircularProgressIndicator()));
        }

        if (state is ProfileError) {
          return Scaffold(appBar: AppBar(title: const Text('Hồ sơ của bạn')), body: Center(child: Text(state.message)));
        }

        if (state is ProfileLoaded) {
          return _buildProfileUI(context, state);
        }
        
        return const Scaffold(body: Center(child: Text('Trạng thái không xác định')));
      },
    );
  }

  Widget _buildProfileUI(BuildContext context, ProfileLoaded state) {
    final displayName = state.displayName.replaceFirst('[OWNER] ', '').replaceFirst('[PARTNER] ', '');
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background, // Màu nền nhất quán
      appBar: AppBar(
        title: const Text('Hồ sơ của bạn'),
        backgroundColor: AppColors.surface,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kSpacingS),
            child: TextButton(
              onPressed: state.isSaving ? null : () => context.read<OwnerProfileCubit>().saveProfile(),
              child: state.isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Lưu'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: kSpacingL, horizontal: kSpacingM),
        child: Column(
          children: [
            _buildHeader(context, state, displayName, textTheme),
            vSpaceL,
            _buildSectionCard(context, 'Thông tin cá nhân', [
              ProfileMenuItem(icon: Icons.person_outline, title: 'Tên hiển thị', value: displayName, onTap: () => _showEditDisplayNameDialog(context, displayName)),
              ProfileMenuItem(icon: Icons.phone_outlined, title: 'Số điện thoại', value: state.phoneNumber, onTap: () => _showEditPhoneNumberDialog(context, state.phoneNumber)),
              ProfileMenuItem(icon: Icons.location_on_outlined, title: 'Địa chỉ', value: state.address, onTap: () => _showEditAddressDialog(context, state.address)),
              ProfileMenuItem(icon: Icons.transgender_outlined, title: 'Giới tính', value: state.gender, onTap: () => _showGenderSelectionSheet(context, state.gender)),
            ]),
            vSpaceL,
            _buildSectionCard(context, 'Bảo mật', [
              ProfileMenuItem(icon: Icons.lock_outline, title: 'Đổi mật khẩu', onTap: () => _showChangePasswordDialog(context)),
            ]),
            vSpaceL,
            _buildLogoutCard(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, ProfileLoaded state, String displayName, TextTheme textTheme) {
    return Column(
      children: [
        ProfileAvatar(
          radius: 50,
          photoURL: state.photoURL,
          fallbackText: displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'P',
          onImageSelected: (XFile imageFile) => context.read<OwnerProfileCubit>().uploadAndSaveAvatar(imageFile),
        ),
        vSpaceM,
        Text(displayName, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        vSpaceXS,
        Text(state.userData['email'] ?? 'Không có email', style: textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> items) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, kSpacingS),
            child: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.8)),
          ),
          // SỬA LỖI: Truyền context vào để vẽ đường kẻ phân cách
          ...ListTile.divideTiles(
            context: context,
            tiles: items,
          ).toList(),
        ],
      ),
    );
  }
  
  Widget _buildLogoutCard(BuildContext context) {
    // SỬA ĐỔI: Xóa BlocListener không cần thiết và không đúng ngữ cảnh
    return Card(
       elevation: 2,
       shadowColor: Colors.black.withOpacity(0.05),
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ProfileMenuItem(
        icon: Icons.logout,
        title: 'Đăng xuất',
        textColor: AppColors.error, // Làm nổi bật màu chữ
        // SỬA ĐỔI: Gọi logout từ OwnerProfileCubit
        onTap: () => context.read<OwnerProfileCubit>().logout(),
        isEditable: false,
      ),
    );
  }
  
  // --- CÁC HÀM XỬ LÝ DIALOG/SHEET ---
  Future<void> _showEditDisplayNameDialog(BuildContext context, String initialValue) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditDisplayNameDialog(initialValue: initialValue),
    );
    if (newName != null && newName.isNotEmpty && context.mounted) {
      context.read<OwnerProfileCubit>().updateDisplayName(newName);
    }
  }

  Future<void> _showEditPhoneNumberDialog(BuildContext context, String initialValue) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          EditPhoneNumberDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newPhoneNumber != null && newPhoneNumber.isNotEmpty && context.mounted) {
      context.read<OwnerProfileCubit>().updatePhoneNumber(newPhoneNumber);
    }
  }

  Future<void> _showEditAddressDialog(BuildContext context, String initialValue) async {
    final newAddress = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          EditAddressDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newAddress != null && newAddress.isNotEmpty && context.mounted) {
      context.read<OwnerProfileCubit>().updateAddress(newAddress);
    }
  }

  Future<void> _showGenderSelectionSheet(BuildContext context, String initialValue) async {
    final newGender = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => GenderSelectionSheet(initialValue: initialValue),
    );
    if (newGender != null && newGender.isNotEmpty && context.mounted) {
      context.read<OwnerProfileCubit>().updateGender(newGender);
    }
  }
  
  Future<void> _showChangePasswordDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const ChangePasswordDialog());
  }
}
