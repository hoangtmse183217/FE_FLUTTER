import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/features/auth/pages/login_page.dart';
import 'package:mumiappfood/features/splash/pages/splash_page.dart';

import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/owner/owner_login_page.dart';
import '../features/auth/pages/owner/owner_register_page.dart';
import '../features/auth/pages/register_page.dart';

class AppRouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String ownerLogin = 'ownerLogin';
  static const String ownerRegister = 'ownerRegister';
  static const String forgotPassword = 'forgotPassword';
// Bạn có thể xóa các tên route không dùng đến
// static const String home = 'home';
// static const String recipeDetails = 'recipeDetails';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: AppRouteNames.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),

      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),

      GoRoute(
        path: '/forgot-password',
        name: AppRouteNames.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),

      GoRoute(
        path: '/owner-login',
        name: AppRouteNames.ownerLogin,
        builder: (BuildContext context, GoRouterState state) {
          return const OwnerLoginPage();
        },
      ),
      GoRoute(
        path: '/owner-register',
        name: AppRouteNames.ownerRegister,
        builder: (BuildContext context, GoRouterState state) {
          return const OwnerRegisterPage();
        },
      ),
    ],
  );
}