import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_register_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';
import '../../widgets/auth_mode_switcher.dart';
import '../../widgets/owner/owner_register_form.dart';

class OwnerRegisterPage extends StatelessWidget {
  const OwnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerRegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký Đối tác'),
        ),
        body: BlocListener<OwnerRegisterCubit, OwnerRegisterState>(
          listener: (context, state) {
            if (state is OwnerRegisterSuccess) {
              // Hiển thị thông báo thành công
              AppSnackbar.showSuccess(context, 'Tạo tài khoản thành công! Đang chuyển đến trang quản lý...');

              context.goNamed(AppRouteNames.ownerDashboard);

            } else if (state is OwnerRegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kSpacingL, vertical: kSpacingM),
              child: Column(
                children: [
                  Text(
                    'Tạo tài khoản Đối tác',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  vSpaceS,
                  const Text(
                    'Bắt đầu đưa nhà hàng của bạn đến với mọi người.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  vSpaceXL,
                  const OwnerRegisterForm(),
                  vSpaceL,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Đã là đối tác?"),
                      TextButton(
                        onPressed: () => context.goNamed(AppRouteNames.ownerLogin),
                        child: const Text('Đăng nhập'),
                      ),
                    ],
                  ),
                  AuthModeSwitcher(
                    label: 'Bạn là người dùng?',
                    actionText: 'Quay lại',
                    onPressed: () => context.goNamed(AppRouteNames.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}