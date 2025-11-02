import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';

typedef OnRegisterSubmit = void Function(
    String email, String password, String fullName);

class RegisterForm extends StatefulWidget {
  final OnRegisterSubmit onSubmit;
  final bool isLoading;

  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            enabled: !widget.isLoading,
          ),
          vSpaceM,
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Nhập email của bạn',
            prefixIcon: Icons.email_outlined,
            validator: ValidatorUtils.email,
            enabled: !widget.isLoading,
          ),
          vSpaceM,
          AppTextField(
            controller: _passwordController,
            labelText: 'Mật khẩu',
            hintText: 'Nhập mật khẩu của bạn',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: ValidatorUtils.password,
            enabled: !widget.isLoading,
          ),
          vSpaceM,
          AppTextField(
            controller: _confirmPasswordController,
            labelText: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu của bạn',
            prefixIcon: Icons.lock_reset_outlined,
            isPassword: true,
            enabled: !widget.isLoading,
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
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
