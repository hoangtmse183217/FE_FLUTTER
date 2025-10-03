import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../routes/app_router.dart';
import '../state/forgot_password_cubit.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Quên mật khẩu'),
        ),
        body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              AppSnackbar.showSuccess(context, state.message);
              context.goNamed(AppRouteNames.login);
            } else if (state is ForgotPasswordFailure) {
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
                    const Text(
                      'Đặt lại mật khẩu',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    vSpaceS,
                    const Text(
                      'Nhập email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    vSpaceXL,
                    const ForgotPasswordForm(),
                    vSpaceL, // Thêm một khoảng trống trước nút quay lại
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => context.goNamed(AppRouteNames.login),
                          child: const Text('Quay lại Đăng nhập'),
                        ),
                      ],
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