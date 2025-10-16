import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/login_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
              context.goNamed(AppRouteNames.home);
            } else if (state is LoginFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Nút quay lại
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: () => context.goNamed(AppRouteNames.roleSelection),
                    tooltip: 'Quay lại chọn vai trò',
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacingL,
                      vertical: kSpacingL,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- Logo App ---
                        SvgPicture.asset(
                          'assets/images/branding/logo.svg',
                          width: 120,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        vSpaceM,

                        // --- Tiêu đề ---
                        Text(
                          'Chào mừng trở lại!',
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
                          'Đăng nhập để khám phá những món ăn theo cảm xúc của bạn',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppColors.textSecondary.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                        vSpaceXL,

                        // --- Khung LoginForm ---
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
                          child: const LoginForm(),
                        ),

                        vSpaceL,

                        // --- Đăng ký ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có tài khoản?',
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.9),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.goNamed(AppRouteNames.register),
                              child: const Text(
                                'Đăng ký ngay',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
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
