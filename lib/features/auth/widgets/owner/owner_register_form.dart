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
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      // 3. Gọi hàm từ Cubit khi người dùng nhấn nút
      context.read<OwnerRegisterCubit>().register(
        restaurantName: _restaurantNameController.text.trim(),
        // Cần thêm các trường khác nếu logic Cubit yêu cầu
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Lắng nghe state để cập nhật UI (nút loading)
    return BlocBuilder<OwnerRegisterCubit, OwnerRegisterState>(
      builder: (context, state) {
        final isLoading = state is OwnerRegisterLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thông tin nhà hàng', style: TextStyle(fontWeight: FontWeight.bold)),
              vSpaceS,
              AppTextField(
                controller: _restaurantNameController,
                labelText: 'Tên nhà hàng',
                hintText: 'Nhập tên nhà hàng của bạn',
                prefixIcon: Icons.restaurant_menu,
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,
              AppTextField(
                controller: _addressController,
                labelText: 'Địa chỉ',
                hintText: 'Nhập địa chỉ kinh doanh',
                prefixIcon: Icons.location_on_outlined,
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,
              AppTextField(
                controller: _phoneController,
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại liên hệ',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceL,
              const Text('Thông tin tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
              vSpaceS,
              AppTextField(
                controller: _emailController,
                labelText: 'Email quản lý',
                hintText: 'Nhập email để quản lý tài khoản',
                prefixIcon: Icons.email_outlined,
                validator: ValidatorUtils.email,
              ),
              vSpaceM,
              AppTextField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                hintText: 'Tạo mật khẩu cho tài khoản',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                validator: ValidatorUtils.password,
              ),
              vSpaceXL,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Gửi đơn đăng ký',
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