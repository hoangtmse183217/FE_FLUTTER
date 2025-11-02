import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_login_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/auth_form_container.dart';
import 'package:mumiappfood/features/auth/widgets/auth_header.dart';
import 'package:mumiappfood/features/auth/widgets/login_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerLoginPage extends StatelessWidget {
  const OwnerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerLoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.goNamed(AppRouteNames.roleSelection),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<OwnerLoginCubit, OwnerLoginState>(
          listener: (context, state) {
            if (state is OwnerLoginSuccess) {
              context.goNamed(AppRouteNames.ownerDashboard);
              AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
            } else if (state is OwnerLoginFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is OwnerLoginLoading;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthHeader(
                      icon: Icons.storefront_outlined,
                      title: 'Tài khoản Đối tác',
                      subtitle: 'Quản lý nhà hàng và thực đơn của bạn.',
                    ),
                    vSpaceXL,
                    AuthFormContainer(
                      child: LoginForm(
                        isLoading: isLoading,
                        onSubmit: (email, password) {
                          // SỬA LỖI: Thêm tên cho tham số
                          context.read<OwnerLoginCubit>().login(email: email, password: password);
                        },
                        // Không có onGoogleLogin cho owner
                      ),
                    ),
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
                  ],
                ), 
              ),
            );
          },
        ),
      ),
    );
  }
}
