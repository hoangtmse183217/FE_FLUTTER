import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_login_cubit.dart';

class OwnerLoginForm extends StatefulWidget {
  const OwnerLoginForm({super.key});

  @override
  State<OwnerLoginForm> createState() => _OwnerLoginFormState();
}

class _OwnerLoginFormState extends State<OwnerLoginForm> {
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
      // 3. Gọi hàm từ Cubit khi người dùng nhấn nút
      context.read<OwnerLoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Lắng nghe state để cập nhật UI (nút loading)
    return BlocBuilder<OwnerLoginCubit, OwnerLoginState>(
      builder: (context, state) {
        final isLoading = state is OwnerLoginLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                labelText: 'Email Kinh doanh',
                hintText: 'Nhập email kinh doanh của bạn',
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading ? null : () {},
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              vSpaceM,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Đăng nhập',
                  isLoading: isLoading,
                  onPressed: _submitLogin,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}