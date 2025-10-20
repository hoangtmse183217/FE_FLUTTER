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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

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
              ),

              // --- FORGOT PASSWORD ---
              Padding(
                padding: const EdgeInsets.only(top: kSpacingS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 🔗 Forgot password
                    TextButton(
                      onPressed: isLoading
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
                  isLoading: isLoading,
                  onPressed: _submitLogin,
                ),
              ),

              // --- SOCIAL LOGIN ---
              const OrDivider(),
              SocialLoginButton(
                iconPath: 'assets/images/icon/google.svg',
                text: 'Đăng nhập với Google',
                onPressed: isLoading
                    ? () {}
                    : () => context.read<LoginCubit>().loginWithGoogle(),
              ),
            ],
          ),
        );
      },
    );
  }
}
