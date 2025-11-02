import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/or_divider.dart';
import 'package:mumiappfood/features/auth/widgets/social_login_button.dart';
import 'package:mumiappfood/routes/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext cubitContext) {
    if (_formKey.currentState!.validate()) {
      cubitContext.read<LoginCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
            // SỬA LỖI: Thay vì pop, điều hướng cụ thể về trang chọn vai trò
            onPressed: () => context.goNamed(AppRouteNames.roleSelection),
          ),
        ),
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
                  context.goNamed(AppRouteNames.home);
                }
              });
            } else if (state is LoginFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final isLoading = state is LoginLoading;
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset('assets/images/branding/logo.svg', height: 80),
                        vSpaceL,
                        Text('Chào mừng trở lại', textAlign: TextAlign.center, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        vSpaceS,
                        Text('Đăng nhập để tiếp tục khám phá ẩm thực', textAlign: TextAlign.center, style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                        vSpaceXL,

                        AppTextField(controller: _emailController, labelText: 'Email', hintText: 'Nhập email của bạn', prefixIcon: Icons.email_outlined, validator: ValidatorUtils.email, enabled: !isLoading),
                        vSpaceM,
                        AppTextField(controller: _passwordController, labelText: 'Mật khẩu', hintText: 'Nhập mật khẩu của bạn', prefixIcon: Icons.lock_outline, isPassword: true, validator: ValidatorUtils.password, enabled: !isLoading),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading ? null : () => context.goNamed(AppRouteNames.forgotPassword),
                            child: const Text('Quên mật khẩu?'),
                          ),
                        ),
                        vSpaceM,

                        AppButton(text: 'Đăng nhập', isLoading: isLoading, onPressed: () => _submitLogin(context)),
                        const OrDivider(),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialLoginButton(
                              iconPath: 'assets/images/icon/google.svg',
                              onPressed: isLoading ? null : () => context.read<LoginCubit>().loginWithGoogle(),
                            ),
                          ],
                        ),
                        vSpaceL,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Chưa có tài khoản?', style: TextStyle(color: AppColors.textSecondary)),
                            TextButton(
                              onPressed: isLoading ? null : () => context.goNamed(AppRouteNames.register),
                              child: const Text('Đăng ký ngay'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
