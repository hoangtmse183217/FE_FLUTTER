import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/register_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _fullNameController,
                labelText: 'Họ và tên',
                hintText: 'Nhập họ và tên của bạn',
                prefixIcon: Icons.person_outline,
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Nhập email của bạn',
                prefixIcon: Icons.email_outlined,
                validator: ValidatorUtils.email,
              ),
              vSpaceM,
              AppTextField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu của bạn',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                validator: ValidatorUtils.password,
              ),
              vSpaceM,
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu của bạn',
                prefixIcon: Icons.lock_reset_outlined,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng không để trống';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp.';
                  }
                  return null;
                },
              ),
              vSpaceL,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Đăng ký',
                  isLoading: isLoading,
                  onPressed: _submitRegister,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}