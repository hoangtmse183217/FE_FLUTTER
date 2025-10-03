import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/features/splash/state/splash_cubit.dart';
import 'package:mumiappfood/features/splash/widgets/animated_splash_logo.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..initializeApp(),
      child: BlocListener<SplashCubit, SplashState>(
        // Lắng nghe trạng thái thay đổi để điều hướng
        listener: (context, state) {
          if (state is SplashLoaded) {
            // Sử dụng go_router để thay thế stack màn hình hiện tại
            // bằng màn hình mới, tránh việc người dùng có thể back lại splash.
            context.go(state.destinationRoute);
          }
        },
        child: const Scaffold(
          body: Center(
            child: AnimatedSplashLogo(),
          ),
        ),
      ),
    );
  }
}