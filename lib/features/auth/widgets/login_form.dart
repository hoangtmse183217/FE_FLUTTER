import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/or_divider.dart';
import 'package:mumiappfood/features/auth/widgets/social_login_button.dart';
import '../../../core/constants/colors.dart';
import '../../../routes/app_router.dart';

typedef OnLoginSubmit = void Function(String email, String password);

class LoginForm extends StatefulWidget {
  // SỬA LỖI: Thêm các callback
  final OnLoginSubmit onSubmit;
  final VoidCallback? onGoogleLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onSubmit,
    this.onGoogleLogin,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // --- EMAIL ---
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Nhập email của bạn',
            prefixIcon: Icons.email_outlined,
            validator: ValidatorUtils.email,
            enabled: !widget.isLoading,
          ),
          vSpaceM,

          // --- PASSWORD ---
          AppTextField(
            controller: _passwordController,
            labelText: 'Mật khẩu',
            hintText: 'Nhập mật khẩu của bạn',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: ValidatorUtils.password,
            enabled: !widget.isLoading,
          ),

          // --- FORGOT PASSWORD ---
          Padding(
            padding: const EdgeInsets.only(top: kSpacingS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.isLoading
                      ? null
                      : () => context.goNamed(AppRouteNames.forgotPassword),
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          vSpaceM,

          // --- PRIMARY BUTTON ---
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Đăng nhập',
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ),

          // --- SOCIAL LOGIN (Optional) ---
          if (widget.onGoogleLogin != null) ...[
            const OrDivider(),
            SocialLoginButton(
              iconPath: 'assets/images/icon/google.svg',
              onPressed: widget.isLoading ? () {} : widget.onGoogleLogin!,
            ),
          ],
        ],
      ),
    );
  }
}
