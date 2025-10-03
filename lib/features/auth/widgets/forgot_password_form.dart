import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/forgot_password_cubit.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().requestPasswordReset(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        return Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Nhập email đã đăng ký của bạn',
                prefixIcon: Icons.email_outlined,
                validator: ValidatorUtils.email,
              ),
              vSpaceL,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Gửi yêu cầu',
                  isLoading: isLoading,
                  onPressed: _submitRequest,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}