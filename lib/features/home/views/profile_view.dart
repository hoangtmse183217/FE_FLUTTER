import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/core/theme/theme_cubit.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/state/profile_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_display_name_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/edit_phone_number_dialog.dart';
import 'package:mumiappfood/features/home/widgets/profile/gender_selection_sheet.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_avatar.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../../../core/locale/locale_cubit.dart';
import '../../../core/locale/locale_state.dart';
import '../../../core/theme/theme_state.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/profile/edit_address_dialog.dart';

/// Lớp này chịu trách nhiệm cung cấp ProfileCubit
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

/// Lớp này chứa UI và các hàm xử lý sự kiện
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  // --- CÁC HÀM XỬ LÝ SỰ KIỆN ---

  Future<void> _showEditDisplayNameDialog(BuildContext context, String initialValue) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => EditDisplayNameDialog(initialValue: initialValue),
    );
    if (newName != null && newName.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateDisplayName(newName);
    }
  }

  Future<void> _showEditPhoneNumberDialog(BuildContext context, String initialValue) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          EditPhoneNumberDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newPhoneNumber != null && newPhoneNumber.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updatePhoneNumber(newPhoneNumber);
    }
  }

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

  Future<void> _showEditAddressDialog(BuildContext context, String initialValue) async {
    final newAddress = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          EditAddressDialog(initialValue: initialValue == 'Chưa cập nhật' ? '' : initialValue),
    );
    if (newAddress != null && newAddress.isNotEmpty && context.mounted) {
      context.read<ProfileCubit>().updateAddress(newAddress);
    }
  }

  /// Hiển thị dialog chọn theme
  Future<void> _showThemeSelectionDialog(BuildContext context) async {
    final themeCubit = context.read<ThemeCubit>();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.theme),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppThemeOptions.values.map((theme) {
                return ListTile(
                  title: Text(_getThemeName(theme)),
                  onTap: () {
                    themeCubit.setTheme(theme);
                    Navigator.of(dialogContext).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLanguageSelectionDialog(BuildContext context) async {
    final localeCubit = context.read<LocaleCubit>();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tiếng Việt'),
                onTap: () {
                  localeCubit.setLocale(const Locale('vi'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  localeCubit.setLocale(const Locale('en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: const Text('中文'),
                onTap: () {
                  localeCubit.setLocale(const Locale('zh'));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getThemeName(AppThemeOptions theme) {
    switch (theme) {
      case AppThemeOptions.dark:
        return 'Tối';
      case AppThemeOptions.warm:
        return 'Ấm';
      case AppThemeOptions.ocean:
        return 'Biển';
      case AppThemeOptions.forest:
        return 'Rừng';
      case AppThemeOptions.aurora:
        return 'Cực quang';
      case AppThemeOptions.light:
      default:
        return 'Sáng';
    }
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'vi':
      default:
        return 'Tiếng Việt';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaveSuccess) {
          AppSnackbar.showSuccess(context, localizations.save);
        } else if (state is ProfileError && state.message.isNotEmpty) {
          AppSnackbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.myProfile)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.myProfile)),
            body: Center(child: Text(state.message)),
          );
        }

        if (state is ProfileLoaded) {
          final loadedState = state;

          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.myProfile),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextButton(
                    onPressed: loadedState.isSaving
                        ? null
                        : () => context.read<ProfileCubit>().saveProfile(),
                    child: loadedState.isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(localizations.save,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    fallbackText: loadedState.displayName.isNotEmpty
                        ? loadedState.displayName.substring(0, 1).toUpperCase()
                        : 'U',
                    onImageSelected: (XFile imageFile) =>
                        context.read<ProfileCubit>().updateAvatar(imageFile),
                  ),
                  vSpaceM,
                  Text(loadedState.displayName,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    loadedState.userData['email'] ?? localizations.noEmail,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  vSpaceXL,
                  Card(
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: localizations.displayName,
                          value: loadedState.displayName,
                          onTap: () => _showEditDisplayNameDialog(context, loadedState.displayName),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.phone_outlined,
                          title: localizations.phoneNumber,
                          value: loadedState.phoneNumber,
                          onTap: () =>
                              _showEditPhoneNumberDialog(context, loadedState.phoneNumber),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: localizations.address,
                          value: loadedState.address,
                          onTap: () => _showEditAddressDialog(context, loadedState.address),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.transgender_outlined,
                            title: localizations.gender,
                          value: loadedState.gender,
                          onTap: () => _showGenderSelectionSheet(context, loadedState.gender),
                        ),
                      ],
                    ),
                  ),
                  vSpaceL,
                  Card(
                    child: Column(
                      children: [
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, themeState) {
                            return ProfileMenuItem(
                              icon: Icons.color_lens_outlined,
                              title: localizations.theme,
                              value: _getThemeName(themeState.appTheme),
                              onTap: () => _showThemeSelectionDialog(context),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, localeState) {
                            return ProfileMenuItem(
                              icon: Icons.language_outlined,
                              title: localizations.language,
                              value: _getLanguageName(localeState.locale),
                              onTap: () => _showLanguageSelectionDialog(context),
                            );
                          },
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
                        title: localizations.logout,
                        onTap: () => context.read<HomeCubit>().logout(),
                        isEditable: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(localizations.myProfile)),
          body: const Center(child: Text('Trạng thái không xác định')),
        );
      },
    );
  }
}
