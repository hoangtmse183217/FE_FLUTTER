import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/forgot_password_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/forgot_password_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerForgotPasswordPage extends StatefulWidget {
  const OwnerForgotPasswordPage({super.key});

  @override
  State<OwnerForgotPasswordPage> createState() => _OwnerForgotPasswordPageState();
}

class _OwnerForgotPasswordPageState extends State<OwnerForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              AppSnackbar.showSuccess(context, state.message);
              final email = _emailController.text.trim();
              // Điều hướng đến trang reset password của Owner
              context.pushNamed(AppRouteNames.ownerResetPassword, extra: {'email': email, 'token': state.resetToken});
            } else if (state is ForgotPasswordFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- NÚT QUAY LẠI ---
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: () => context.goNamed(AppRouteNames.ownerLogin),
                    tooltip: 'Quay lại trang đăng nhập',
                  ),
                ),

                // --- NỘI DUNG CHÍNH ---
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_reset, size: 64),
                          vSpaceM,
                          const Text(
                            'Đặt lại mật khẩu Đối tác',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          vSpaceS,
                          const Text(
                            'Nhập email của bạn và chúng tôi sẽ gửi OTP.',
                            textAlign: TextAlign.center,
                          ),
                          vSpaceXL,
                          ForgotPasswordForm(emailController: _emailController),
                        ],
                      ),
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
