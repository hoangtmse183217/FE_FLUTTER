import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/forgot_password_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/forgot_password_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

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
        appBar: AppBar(
          title: const Text('Quên mật khẩu'),
        ),
        body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              AppSnackbar.showSuccess(context, state.message);

              final email = _emailController.text.trim();
              final token = state.resetToken;

              context.pushNamed(
                AppRouteNames.resetPassword,
                extra: {'email': email, 'token': token},
              );
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
                      'Nhập email của bạn và chúng tôi sẽ gửi cho bạn một OTP để đặt lại mật khẩu.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    vSpaceXL,
                    // 4. TRUYỀN CONTROLLER VÀO FORM
                    ForgotPasswordForm(emailController: _emailController),
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