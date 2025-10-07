import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_register_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/owner/owner_register_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../../widgets/auth_mode_switcher.dart';

class OwnerRegisterPage extends StatelessWidget {
  const OwnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Cung cấp Cubit cho cây widget
    return BlocProvider(
      create: (context) => OwnerRegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký Đối tác'),
        ),
        // 2. Lắng nghe các thay đổi state để thực hiện hành động
        body: BlocListener<OwnerRegisterCubit, OwnerRegisterState>(
          listener: (context, state) {
            if (state is OwnerRegisterSuccess) {
              AppSnackbar.showSuccess(context, 'Đăng ký thành công! Vui lòng chờ duyệt.');
              context.goNamed(AppRouteNames.ownerLogin);
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
                    'Tham gia cộng đồng Đối tác',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  vSpaceS,
                  const Text(
                    'Đưa món ăn của bạn đến với hàng ngàn người dùng.',
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