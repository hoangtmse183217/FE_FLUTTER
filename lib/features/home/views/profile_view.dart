import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/core/theme/theme_cubit.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/home/state/profile_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile/change_password_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_address_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_display_name_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_phone_number_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/gender_selection_sheet.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_avatar.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/theme_state.dart';
import '../widgets/profile/settings_section.dart';
import '../widgets/profile/settings_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded && state.isSaving) {
                return const Padding(
                  padding: EdgeInsets.only(right: kSpacingM),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))),
                );
              }
              if (state is ProfileLoaded) {
                 return TextButton(
                  onPressed: () => context.read<ProfileCubit>().saveProfile(),
                  child: Text('Save', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSaveSuccess) {
            AppSnackbar.showSuccess(context, 'Saved successfully!');
          } else if (state is ProfileError && state.message.isNotEmpty) {
            AppSnackbar.showError(context, state.message);
          } else if (state is ProfileLogoutSuccess) { // SỬA ĐỔI: Lắng nghe ProfileLogoutSuccess
            context.goNamed(AppRouteNames.roleSelection);
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileLoaded) {
            return _buildProfileContent(context, state);
          }

          return const Center(child: Text('Unknown State'));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(kSpacingM),
      children: [
        _buildUserInfoSection(context, state),
        vSpaceL,
        if (state.userData['role'] == 'Partner') ...[
          _buildPartnerSection(context),
          vSpaceL,
        ],
        _buildAccountSettings(context, state),
        vSpaceL,
        _buildAppSettings(context),
        vSpaceL,
        _buildLogoutSection(context),
      ],
    );
  }

  // --- WIDGETS CON ---

  Widget _buildUserInfoSection(BuildContext context, ProfileLoaded state) {
    return Column(
      children: [
        ProfileAvatar(
          photoURL: state.photoURL,
          fallbackText: state.displayName.isNotEmpty ? state.displayName[0] : 'U',
          onImageSelected: (XFile image) {
            context.read<ProfileCubit>().uploadAndSaveAvatar(image);
          },
        ),
        vSpaceM,
        Text(state.displayName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(state.userData['email'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
      ],
    );
  }
  
  Widget _buildPartnerSection(BuildContext context) {
     return SettingsSection(
      tiles: [
        SettingsTile(
          icon: Icons.storefront_outlined,
          title: 'Management Page',
          onTap: () => context.pushNamed(AppRouteNames.ownerDashboard),
        ),
      ],
    );
  }

  Widget _buildAccountSettings(BuildContext context, ProfileLoaded state) {
    return SettingsSection(
      title: 'Account',
      tiles: [
        SettingsTile(
          icon: Icons.person_outline,
          title: 'Display Name',
          value: state.displayName,
          onTap: () async {
            final newName = await showDialog<String>(context: context, builder: (_) => EditDisplayNameDialog(initialValue: state.displayName));
            if (newName != null && context.mounted) context.read<ProfileCubit>().updateDisplayName(newName);
          },
        ),
        SettingsTile(
          icon: Icons.phone_outlined,
          title: 'Phone Number',
          value: state.phoneNumber,
          onTap: () async {
            final newPhone = await showDialog<String>(context: context, builder: (_) => EditPhoneNumberDialog(initialValue: state.phoneNumber));
            if (newPhone != null && context.mounted) context.read<ProfileCubit>().updatePhoneNumber(newPhone);
          },
        ),
        SettingsTile(
          icon: Icons.location_on_outlined,
          title: 'Address',
          value: state.address,
          onTap: () async {
            final newAddress = await showDialog<String>(context: context, builder: (_) => EditAddressDialog(initialValue: state.address));
            if (newAddress != null && context.mounted) context.read<ProfileCubit>().updateAddress(newAddress);
          },
        ),
        SettingsTile(
          icon: Icons.transgender_outlined,
          title: 'Gender',
          value: state.gender,
          onTap: () async {
            final newGender = await showModalBottomSheet<String>(context: context, builder: (_) => GenderSelectionSheet(initialValue: state.gender));
            if (newGender != null && context.mounted) context.read<ProfileCubit>().updateGender(newGender);
          },
        ),
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => showDialog(context: context, builder: (_) => const ChangePasswordDialog()),
        ),
      ],
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return SettingsSection(
      title: 'App Settings',
      tiles: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDarkMode = AppTheme.getTheme(themeState.appTheme).brightness == Brightness.dark;
            return SettingsTile(
              icon: isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              title: 'Theme',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                activeColor: AppColors.primary,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return SettingsSection(
      showCard: false,
      tiles: [
        SettingsTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () => context.read<ProfileCubit>().logout(),
          isEditable: false,
          textColor: Colors.red,
        ),
      ],
    );
  }
}
