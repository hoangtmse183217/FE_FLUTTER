import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_register_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';
import '../../widgets/auth_mode_switcher.dart';
import '../../widgets/owner/owner_register_form.dart';

class OwnerRegisterPage extends StatelessWidget {
  const OwnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerRegisterCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<OwnerRegisterCubit, OwnerRegisterState>(
          listener: (context, state) {
            if (state is OwnerRegisterSuccess) {
              AppSnackbar.showSuccess(
                context,
                'Tạo tài khoản thành công! Đang chuyển đến trang quản lý...',
              );
              context.goNamed(AppRouteNames.ownerDashboard);
            } else if (state is OwnerRegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Nút quay lại chọn vai trò
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: () =>
                        context.goNamed(AppRouteNames.roleSelection),
                    tooltip: 'Quay lại chọn vai trò',
                  ),
                ),

                // 📄 Nội dung chính
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacingL,
                      vertical: kSpacingL,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🏪 Logo
                        SvgPicture.asset(
                          'assets/images/branding/logo.svg',
                          width: 110,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        vSpaceL,

                        // Tiêu đề
                        Text(
                          'Tạo tài khoản Đối tác',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        vSpaceS,
                        Text(
                          'Đưa nhà hàng của bạn đến gần hơn với thực khách!',
                          textAlign: TextAlign.center,
                          style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary
                                .withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                        vSpaceXL,

                        // 📋 Card chứa form
                        Container(
                          padding: const EdgeInsets.all(kSpacingL),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const OwnerRegisterForm(),
                        ),

                        vSpaceL,

                        // 🔗 Đã có tài khoản?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã là đối tác?',
                              style: TextStyle(
                                color:
                                AppColors.textSecondary.withOpacity(0.9),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.goNamed(AppRouteNames.ownerLogin),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 🔁 Chuyển sang vai trò User
                        AuthModeSwitcher(
                          label: 'Bạn là người dùng?',
                          actionText: 'Đăng nhập tại đây',
                          onPressed: () =>
                              context.goNamed(AppRouteNames.login),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
