import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/splash/state/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..initializeApp(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            context.go(state.destinationRoute);
          }
        },
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo của ứng dụng
                Image.asset(
                  'assets/images/branding/logo.png', // SỬA ĐỔI: Sử dụng đường dẫn chính xác
                  width: 120,
                  height: 120,
                ),
                vSpaceM,
                // Tên ứng dụng
                Text(
                  'MumiAppFood',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const Spacer(),
                // Chỉ báo tải
                const CircularProgressIndicator(),
                const SizedBox(height: kSpacingXL * 2), // Tạo khoảng đệm dưới
              ],
            ),
          ),
        ),
      ),
    );
  }
}
