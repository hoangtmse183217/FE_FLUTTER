import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/register_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/register_form.dart';
import 'package:mumiappfood/routes/app_router.dart';
import '../widgets/auth_mode_switcher.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              AppSnackbar.showSuccess(
                context,
                'Tạo tài khoản thành công! Vui lòng đăng nhập.',
              );
              context.goNamed(AppRouteNames.login);
            } else if (state is RegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacingL,
                vertical: kSpacingL,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Logo ---
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
                    'Tạo tài khoản mới',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  vSpaceS,
                  Text(
                    'Bắt đầu hành trình ẩm thực của bạn ngay hôm nay',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                  vSpaceXL,

                  // --- Khung đăng ký ---
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
                    child: const RegisterForm(),
                  ),

                  vSpaceL,

                  // --- Đăng nhập ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có tài khoản?',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.9),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.goNamed(AppRouteNames.login),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
