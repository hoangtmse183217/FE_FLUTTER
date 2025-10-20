import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Service quản lý token (API riêng của bạn)
import 'package:mumiappfood/core/services/auth_service.dart';

// Auth & Role Selection Pages
import 'package:mumiappfood/features/auth/pages/forgot_password_page.dart';
import 'package:mumiappfood/features/auth/pages/login_page.dart';
import 'package:mumiappfood/features/auth/pages/register_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_login_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_register_page.dart';
import 'package:mumiappfood/features/role_selection/pages/role_selection_page.dart';

// User Flow Pages
import 'package:mumiappfood/features/home/pages/home_page.dart';
import 'package:mumiappfood/features/restaurant_details/pages/restaurant_details_page.dart';
import 'package:mumiappfood/features/post_details/pages/post_details_page.dart';
import 'package:mumiappfood/features/home/pages/notifications_page.dart';

// Owner Flow Pages
import 'package:mumiappfood/features/owner_dashboard/pages/owner_dashboard_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_restaurant_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/restaurant_images_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_post_page.dart';

// General Pages
import 'package:mumiappfood/features/splash/pages/splash_page.dart';

import '../features/auth/pages/reset_password_page.dart';

/// ---------------------------------------------------------------------------
/// Tên route (giữ nguyên)
/// ---------------------------------------------------------------------------
class AppRouteNames {
  static const String splash = 'splash';
  static const String roleSelection = 'roleSelection';

  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String ownerLogin = 'ownerLogin';
  static const String ownerRegister = 'ownerRegister';
  static const String resetPassword = 'resetPassword';

  // User Flow
  static const String home = 'home';
  static const String restaurantDetails = 'restaurantDetails';
  static const String notifications = 'notifications';
  static const String postDetails = 'postDetails';

  // Owner Flow
  static const String ownerDashboard = 'ownerDashboard';
  static const String addRestaurant = 'addRestaurant';
  static const String editRestaurant = 'editRestaurant';
  static const String restaurantImages = 'restaurantImages';
  static const String addPost = 'addPost';
  static const String editPost = 'editPost';

}

/// ---------------------------------------------------------------------------
/// Router chính - DÙNG JWT Token
/// ---------------------------------------------------------------------------
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // Không còn dùng FirebaseAuth nữa — redirect dựa trên token API
    redirect: (BuildContext context, GoRouterState state) async {
      // Lấy token từ AuthService (bạn phải cài đặt hàm này)
      final accessToken = await AuthService.getAccessToken();

      final bool isLoggedIn =
          accessToken != null && !JwtDecoder.isExpired(accessToken);

      // Các trang public ai cũng truy cập được
      final publicPages = [
        '/splash',
        '/role-selection',
        '/login',
        '/register',
        '/forgot-password',
        '/owner-login',
        '/owner-register',
        '/reset-password',
      ];

      final isGoingToPublicPage = publicPages.contains(state.matchedLocation);

      // Nếu đã đăng nhập
      if (isLoggedIn) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
        final String role = decodedToken['role'] ?? 'user';

        if (isGoingToPublicPage) {
          // Chủ quán -> dashboard, người dùng -> home
          return role == 'owner' ? '/owner/dashboard' : '/';
        }
      } else {
        // Nếu chưa đăng nhập mà cố vào trang private -> đưa về role selection
        if (!isGoingToPublicPage) {
          return '/role-selection';
        }
      }

      return null;
    },

    /// -----------------------------------------------------------------------
    /// Tất cả route giữ nguyên logic cũ
    /// -----------------------------------------------------------------------
    routes: <RouteBase>[
      // Public Routes
      GoRoute(path: '/splash', name: AppRouteNames.splash, builder: (c, s) => const SplashPage()),
      GoRoute(path: '/role-selection', name: AppRouteNames.roleSelection, builder: (c, s) => const RoleSelectionPage()),

      // Auth Routes
      GoRoute(path: '/login', name: AppRouteNames.login, builder: (c, s) => const LoginPage()),
      GoRoute(path: '/register', name: AppRouteNames.register, builder: (c, s) => const RegisterPage()),
      GoRoute(path: '/forgot-password', name: AppRouteNames.forgotPassword, builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/owner-login', name: AppRouteNames.ownerLogin, builder: (c, s) => const OwnerLoginPage()),
      GoRoute(path: '/owner-register', name: AppRouteNames.ownerRegister, builder: (c, s) => const OwnerRegisterPage()),

      // User Flow Routes
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
        ],
      ),
      GoRoute(
        path: '/notifications',
        name: AppRouteNames.notifications,
        builder: (c, s) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/post/:postId',
        name: AppRouteNames.postDetails,
        builder: (context, state) {
          final id = state.pathParameters['postId']!;
          return PostDetailsPage(postId: id);
        },
      ),

      // Owner Flow Routes
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
          final id = state.pathParameters['restaurantId']!;
          return AddEditRestaurantPage(restaurantId: id);
        },
      ),
      GoRoute(
        path: '/owner/restaurant/images/:restaurantId',
        name: AppRouteNames.restaurantImages,
        builder: (context, state) {
          final id = state.pathParameters['restaurantId']!;
          return RestaurantImagesPage(restaurantId: id);
        },
      ),
      GoRoute(
        path: '/owner/post/add',
        name: AppRouteNames.addPost,
        builder: (context, state) => const AddEditPostPage(postId: null),
      ),
      GoRoute(
        path: '/owner/post/edit/:postId',
        name: AppRouteNames.editPost,
        builder: (context, state) {
          final id = state.pathParameters['postId']!;
          return AddEditPostPage(postId: id);
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: AppRouteNames.resetPassword,
        builder: (context, state) {
          // Nhận Map từ extra
          final Map<String, String> data = state.extra as Map<String, String>;
          final String email = data['email']!;
          final String token = data['token']!;
          return ResetPasswordPage(email: email, token: token);
        },
      ),
    ],
  );
}
