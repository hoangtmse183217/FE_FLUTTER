import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // <-- 1. Import SvgPicture
import 'package:go_router/go_router.dart';
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
      create: (context) => RegisterCubit(),
      child: Scaffold(
        // Bỏ AppBar để có giao diện tràn lề, nhất quán với trang Login
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              // SỬA LẠI THÔNG BÁO VÀ ĐIỀU HƯỚNG
              AppSnackbar.showSuccess(context, 'Tạo tài khoản thành công! Vui lòng đăng nhập.');

              // Đưa người dùng đến trang đăng nhập của User
              context.goNamed(AppRouteNames.login);

            } else if (state is RegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- 2. THÊM LOGO ---
                    // Tương tự như trang Login để tạo sự nhất quán
                    SvgPicture.asset(
                      'assets/images/branding/logo.svg',
                      width: 80, // Có thể cho nhỏ hơn một chút so với trang Login
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    vSpaceL,

                    // --- TIÊU ĐỀ ---
                    Text(
                      'Tạo tài khoản mới',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    vSpaceS,
                    Text(
                      'Bắt đầu hành trình ẩm thực của bạn ngay hôm nay!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),

                    vSpaceXL,
                    const RegisterForm(),
                    vSpaceL,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Đã có tài khoản?"),
                        TextButton(
                          onPressed: () => context.goNamed(AppRouteNames.login),
                          child: const Text('Đăng nhập'),
                        ),
                      ],
                    ),
                    AuthModeSwitcher(
                      label: 'Chủ nhà hàng?',
                      actionText: 'Đăng ký tại đây',
                      onPressed: () => context.goNamed(AppRouteNames.ownerRegister),
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