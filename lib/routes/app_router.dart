// lib/routes/app_router.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/features/auth/pages/forgot_password_page.dart';

import '../features/address/address_input_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/owner/owner_login_page.dart';
import '../features/auth/pages/owner/owner_register_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/home/pages/notifications_page.dart';
import '../features/restaurant_details/pages/restaurant_details_page.dart';
import '../features/splash/pages/splash_page.dart';


class AppRouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String ownerLogin = 'ownerLogin';
  static const String ownerRegister = 'ownerRegister';
  static const String forgotPassword = 'forgotPassword';
  static const String home = 'home';
  static const String restaurantDetails = 'restaurantDetails';
  static const String notifications = 'notifications';
}

class AppRouter {
  // 1. Tạo một stream Listenable để lắng nghe trạng thái auth
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // 2. Cung cấp stream vào refreshListenable
    // GoRouter sẽ tự động chạy lại redirect khi trạng thái auth thay đổi
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final authRoutes = [
        '/splash', '/login', '/register', '/forgot-password',
        '/owner-login', '/owner-register'
      ];
      final bool isAnAuthRoute = authRoutes.contains(state.matchedLocation);

      if (isLoggedIn && isAnAuthRoute) {
        return '/';
      }

      if (!isLoggedIn && !isAnAuthRoute) {
        return '/login';
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(path: '/splash', name: AppRouteNames.splash, builder: (c, s) => const SplashPage()),
      GoRoute(path: '/', name: AppRouteNames.home, builder: (c, s) => const HomePage()),
      GoRoute(path: '/login', name: AppRouteNames.login, builder: (c, s) => const LoginPage()),
      GoRoute(path: '/register', name: AppRouteNames.register, builder: (c, s) => const RegisterPage()),
      GoRoute(path: '/forgot-password', name: AppRouteNames.forgotPassword, builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/owner-login', name: AppRouteNames.ownerLogin, builder: (c, s) => const OwnerLoginPage()),
      GoRoute(path: '/owner-register', name: AppRouteNames.ownerRegister, builder: (c, s) => const OwnerRegisterPage()),
      GoRoute(path: '/address-input', name: 'addressInput', builder: (c, s) => const AddressInputPage()),
      GoRoute(path: '/notifications', name: AppRouteNames.notifications, builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(path: "/restaurant/:restaurantId", name: AppRouteNames.restaurantDetails,builder: (BuildContext context, GoRouterState state){
        final String restaurantId = state.pathParameters['restaurantId']!;

        // 5. Truyền ID vào trang RestaurantDetailsPage
        return RestaurantDetailsPage(restaurantId: restaurantId);
        }
      ),
    ],
  );
}

// =================================================================
// === LỚP HELPER ĐỂ CHUYỂN ĐỔI STREAM THÀNH LISTENABLE ===
// =================================================================
// Lớp này được cung cấp trong tài liệu chính thức của GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}