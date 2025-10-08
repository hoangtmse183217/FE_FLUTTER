import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth Pages
import 'package:mumiappfood/features/auth/pages/forgot_password_page.dart';
import 'package:mumiappfood/features/auth/pages/login_page.dart';
import 'package:mumiappfood/features/auth/pages/register_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_login_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_register_page.dart';

// User Flow Pages
import 'package:mumiappfood/features/home/pages/home_page.dart';
import 'package:mumiappfood/features/restaurant_details/pages/restaurant_details_page.dart';

// Owner Flow Pages
import 'package:mumiappfood/features/owner_dashboard/pages/owner_dashboard_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_restaurant_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/restaurant_images_page.dart';

// General Pages
import 'package:mumiappfood/features/splash/pages/splash_page.dart';

import '../features/home/pages/notifications_page.dart';

class AppRouteNames {
  static const String splash = 'splash';

  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String ownerLogin = 'ownerLogin';
  static const String ownerRegister = 'ownerRegister';

  // User Flow
  static const String home = 'home';
  static const String restaurantDetails = 'restaurantDetails';
  static const String notifications = 'notifications';

  // Owner Flow
  static const String ownerDashboard = 'ownerDashboard';
  static const String addRestaurant = 'addRestaurant';
  static const String editRestaurant = 'editRestaurant';
  static const String restaurantImages = 'restaurantImages';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    redirect: (BuildContext context, GoRouterState state) {

      final user = FirebaseAuth.instance.currentUser;
      final bool isLoggedIn = user != null;

      final authRoutes = [
        '/splash', '/login', '/register', '/forgot-password',
        '/owner-login', '/owner-register'
      ];
      final bool isAnAuthRoute = authRoutes.contains(state.matchedLocation);

      if (isLoggedIn) {
        final String role = (user.displayName != null && user.displayName!.startsWith('[OWNER]'))
            ? 'owner'
            : 'user';

        if (role == 'owner') {
          final isAtUserArea = state.matchedLocation == '/' ||
              state.matchedLocation.startsWith('/restaurant') ||
              state.matchedLocation == '/notifications';
          if (isAnAuthRoute || isAtUserArea) {
            return '/owner/dashboard';
          }
        } else { // 'user'
          if (isAnAuthRoute) {
            return '/';
          }
        }
      } else {
        if (!isAnAuthRoute) {
          return '/login';
        }
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(path: '/splash', name: AppRouteNames.splash, builder: (c, s) => const SplashPage()),

      // Các route của luồng User
      GoRoute(
        path: '/',
        name: AppRouteNames.home,
        builder: (c, s) => const HomePage(),
        routes: [
          GoRoute(
            path: 'restaurant/:restaurantId',
            name: AppRouteNames.restaurantDetails,
            builder: (context, state) {
              final id = state.pathParameters['restaurantId']!;
              return RestaurantDetailsPage(restaurantId: id);
            },
          ),
          // GoRoute(
          //   path: 'notifications',
          //   name: AppRouteNames.notifications,
          //   builder: (context, state) => const NotificationsPage(),
          // ),
        ],
      ),

      // Các route của luồng Owner
      GoRoute(
        path: '/owner/dashboard',
        name: AppRouteNames.ownerDashboard,
        builder: (context, state) => const OwnerDashboardPage(),
      ),
      GoRoute(
        path: '/owner/restaurant/add',
        name: AppRouteNames.addRestaurant,
        builder: (context, state) => const AddEditRestaurantPage(restaurantId: null),
      ),
      GoRoute(
        path: '/owner/restaurant/edit/:restaurantId',
        name: AppRouteNames.editRestaurant,
        builder: (context, state) {
          final restaurantId = state.pathParameters['restaurantId']!;
          return AddEditRestaurantPage(restaurantId: restaurantId);
        },
      ),
      // THÊM ROUTE MỚI CHO QUẢN LÝ ẢNH
      GoRoute(
        path: '/owner/restaurant/images/:restaurantId',
        name: AppRouteNames.restaurantImages,
        builder: (context, state) {
          final restaurantId = state.pathParameters['restaurantId']!;
          return RestaurantImagesPage(restaurantId: restaurantId);
        },
      ),

      // Các route xác thực (chung)
      GoRoute(path: '/login', name: AppRouteNames.login, builder: (c, s) => const LoginPage()),
      GoRoute(path: '/register', name: AppRouteNames.register, builder: (c, s) => const RegisterPage()),
      GoRoute(path: '/forgot-password', name: AppRouteNames.forgotPassword, builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/owner-login', name: AppRouteNames.ownerLogin, builder: (c, s) => const OwnerLoginPage()),
      GoRoute(path: '/owner-register', name: AppRouteNames.ownerRegister, builder: (c, s) => const OwnerRegisterPage()),
    ],
  );
}

// Lớp GoRouterRefreshStream
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