import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/login_form.dart';

import '../../../routes/app_router.dart';
import '../widgets/auth_mode_switcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        // Bỏ AppBar để có giao diện hiện đại hơn
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
              // context.goNamed(AppRouteNames.home);
            } else if (state is LoginFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Center( // Dùng Center để căn giữa nội dung theo chiều dọc
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các item trong Column
                  children: [
                    // Logo App
                    SvgPicture.asset(
                      'assets/images/branding/logo.svg',
                      width: 100,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    vSpaceL,
                    // Welcome Text
                    Text(
                      'Chào mừng trở lại!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    vSpaceS,
                    Text(
                      'Đăng nhập để khám phá những món ăn theo cảm xúc của bạn',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    vSpaceXL,
                    const LoginForm(),
                    vSpaceL,
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản?"),
                        TextButton(
                          onPressed: () => context.goNamed(AppRouteNames.register),
                          child: const Text('Đăng ký ngay'),
                        ),
                      ],
                    ),
                    AuthModeSwitcher(
                      label: 'Bạn là chủ nhà hàng?',
                      actionText: 'Đăng nhập tại đây',
                      onPressed: () => context.goNamed(AppRouteNames.ownerLogin),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}