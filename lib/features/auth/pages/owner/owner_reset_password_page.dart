import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/reset_password_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerResetPasswordPage extends StatefulWidget {
  final String email;
  final String token;
  const OwnerResetPasswordPage({super.key, required this.email, required this.token});

  @override
  State<OwnerResetPasswordPage> createState() => _OwnerResetPasswordPageState();
}

class _OwnerResetPasswordPageState extends State<OwnerResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().resetPassword(
        email: widget.email,
        token: widget.token,
        otp: _otpController.text.trim(),
        newPassword: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Đặt lại mật khẩu Đối tác')),
        body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              AppSnackbar.showSuccess(context, 'Mật khẩu đã được đặt lại thành công!');
              context.goNamed(AppRouteNames.ownerLogin);
            } else if (state is ResetPasswordFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kSpacingL),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Một mã OTP đã được gửi đến ${widget.email}.'),
                  vSpaceL,
                  AppTextField(controller: _otpController, labelText: 'Mã OTP', hintText: 'Nhập mã OTP', keyboardType: TextInputType.number, validator: ValidatorUtils.notEmpty),
                  vSpaceM,
                  AppTextField(controller: _passwordController, labelText: 'Mật khẩu mới', hintText: 'Nhập mật khẩu mới', isPassword: true, validator: ValidatorUtils.password),
                  vSpaceM,
                  AppTextField(controller: _confirmPasswordController, labelText: 'Xác nhận mật khẩu mới', hintText: 'Nhập lại mật khẩu mới', isPassword: true, validator: (value) {
                    if (value != _passwordController.text) return 'Mật khẩu không khớp.';
                    return null;
                  }),
                  vSpaceXL,
                  BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                    builder: (buttonContext, state) {
                      return AppButton(
                        text: 'Xác nhận',
                        isLoading: state is ResetPasswordLoading,
                        onPressed: () => _submit(buttonContext),
                      );
                    },
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
