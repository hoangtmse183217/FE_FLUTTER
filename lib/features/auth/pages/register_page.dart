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
import 'package:mumiappfood/features/auth/state/register_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegister(BuildContext cubitContext) {
    if (_formKey.currentState!.validate()) {
      cubitContext.read<RegisterCubit>().register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => RegisterCubit(),
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
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              AppSnackbar.showSuccess(context, 'Tạo tài khoản thành công! Vui lòng đăng nhập.');
              context.goNamed(AppRouteNames.login);
            } else if (state is RegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
              child: BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final isLoading = state is RegisterLoading;
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset('assets/images/branding/logo.svg', height: 80),
                        vSpaceL,
                        Text('Tạo tài khoản mới', textAlign: TextAlign.center, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        vSpaceS,
                        Text('Bắt đầu hành trình ẩm thực của bạn ngay hôm nay', textAlign: TextAlign.center, style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                        vSpaceXL,

                        AppTextField(controller: _fullNameController, labelText: 'Họ và tên', hintText: 'Nhập họ và tên của bạn', prefixIcon: Icons.person_outline, validator: ValidatorUtils.notEmpty, enabled: !isLoading),
                        vSpaceM,
                        AppTextField(controller: _emailController, labelText: 'Email', hintText: 'Nhập email của bạn', prefixIcon: Icons.email_outlined, validator: ValidatorUtils.email, enabled: !isLoading),
                        vSpaceM,
                        AppTextField(controller: _passwordController, labelText: 'Mật khẩu', hintText: 'Nhập mật khẩu của bạn', prefixIcon: Icons.lock_outline, isPassword: true, validator: ValidatorUtils.password, enabled: !isLoading),
                        vSpaceM,
                        AppTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Xác nhận mật khẩu',
                          hintText: 'Nhập lại mật khẩu của bạn',
                          prefixIcon: Icons.lock_reset_outlined,
                          isPassword: true,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Vui lòng không để trống';
                            if (value != _passwordController.text) return 'Mật khẩu không khớp.';
                            return null;
                          },
                        ),
                        vSpaceXL,

                        AppButton(text: 'Đăng ký', isLoading: isLoading, onPressed: () => _submitRegister(context)),
                        vSpaceL,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Đã có tài khoản?', style: TextStyle(color: AppColors.textSecondary)),
                            TextButton(
                              onPressed: isLoading ? null : () => context.goNamed(AppRouteNames.login),
                              child: const Text('Đăng nhập ngay'),
                            ),
                          ],
                        ),
                         vSpaceL, 
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
