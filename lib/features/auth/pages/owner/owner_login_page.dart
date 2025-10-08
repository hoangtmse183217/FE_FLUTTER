import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/auth_mode_switcher.dart';
import 'package:mumiappfood/features/auth/widgets/owner/owner_login_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerLoginPage extends StatelessWidget {
  const OwnerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerLoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Partner Portal'),
        ),
        // SỬA LẠI: Chỉ cần lắng nghe lỗi để hiển thị SnackBar
        body: BlocListener<OwnerLoginCubit, OwnerLoginState>(
          listener: (context, state) {
            // Chúng ta không cần xử lý state Success nữa vì GoRouter đã làm điều đó
            if (state is OwnerLoginFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    vSpaceL,
                    Text(
                      'Đăng nhập tài khoản Đối tác',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    vSpaceS,
                    const Text(
                      'Quản lý nhà hàng và thực đơn của bạn.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    vSpaceXL,
                    // OwnerLoginForm sẽ được rebuild bởi BlocBuilder bên trong nó
                    const OwnerLoginForm(),
                    vSpaceL,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản đối tác?"),
                        TextButton(
                          onPressed: () => context.goNamed(AppRouteNames.ownerRegister),
                          child: const Text('Đăng ký ngay'),
                        ),
                      ],
                    ),
                    AuthModeSwitcher(
                      label: 'Tìm kiếm món ăn?',
                      actionText: 'Quay lại',
                      onPressed: () => context.goNamed(AppRouteNames.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}