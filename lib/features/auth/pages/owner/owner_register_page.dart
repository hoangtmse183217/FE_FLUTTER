import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/auth/state/owner/owner_register_cubit.dart';
import 'package:mumiappfood/features/auth/widgets/auth_form_container.dart';
import 'package:mumiappfood/features/auth/widgets/auth_header.dart';
import 'package:mumiappfood/features/auth/widgets/register_form.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerRegisterPage extends StatelessWidget {
  const OwnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerRegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.goNamed(AppRouteNames.roleSelection),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<OwnerRegisterCubit, OwnerRegisterState>(
          listener: (context, state) {
            if (state is OwnerRegisterSuccess) {
              AppSnackbar.showSuccess(context, 'Tạo tài khoản thành công! Vui lòng đăng nhập.');
              context.goNamed(AppRouteNames.ownerLogin);
            } else if (state is OwnerRegisterFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is OwnerRegisterLoading;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthHeader(
                      icon: Icons.storefront_outlined,
                      title: 'Tạo tài khoản Đối tác',
                      subtitle: 'Đưa nhà hàng của bạn đến gần hơn với thực khách!',
                    ),
                    vSpaceXL,
                    AuthFormContainer(
                      child: RegisterForm(
                        isLoading: isLoading,
                        onSubmit: (email, password, fullName) {
                          context.read<OwnerRegisterCubit>().register(
                                email: email,
                                password: password,
                                fullName: fullName,
                              );
                        },
                      ),
                    ),
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
