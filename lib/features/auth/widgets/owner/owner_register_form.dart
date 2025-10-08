// lib/features/auth/widgets/owner/owner_register_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_register_cubit.dart';

class OwnerRegisterForm extends StatefulWidget {
  const OwnerRegisterForm({super.key});

  @override
  State<OwnerRegisterForm> createState() => _OwnerRegisterFormState();
}

class _OwnerRegisterFormState extends State<OwnerRegisterForm> {
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
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<OwnerRegisterCubit>().register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerRegisterCubit, OwnerRegisterState>(
      builder: (context, state) {
        final isLoading = state is OwnerRegisterLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _fullNameController,
                labelText: 'Họ và tên người đại diện',
                hintText: 'Nhập họ và tên của bạn',
                prefixIcon: Icons.person_outline,
                validator: ValidatorUtils.notEmpty,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              vSpaceM,
              AppTextField(
                controller: _emailController,
                labelText: 'Email kinh doanh',
                hintText: 'Nhập email của bạn',
                prefixIcon: Icons.email_outlined,
                validator: ValidatorUtils.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              vSpaceM,
              AppTextField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                hintText: 'Tạo mật khẩu cho tài khoản',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                validator: ValidatorUtils.password,
                textInputAction: TextInputAction.next,
              ),
              vSpaceM,
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu của bạn',
                prefixIcon: Icons.lock_reset_outlined,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng không để trống';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submitRegister(),
              ),
              vSpaceXL,
              AppButton(
                text: 'Tạo tài khoản Đối tác',
                isLoading: isLoading,
                onPressed: _submitRegister,
              ),
            ],
          ),
        );
      },
    );
  }
}