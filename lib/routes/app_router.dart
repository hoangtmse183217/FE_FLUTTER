import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

// Owner Flow Pages
import 'package:mumiappfood/features/owner_dashboard/pages/owner_dashboard_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_restaurant_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/restaurant_images_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_post_page.dart';

// General Pages
import 'package:mumiappfood/features/splash/pages/splash_page.dart';

import '../features/home/pages/notifications_page.dart';

class AppRouteNames {
  static const String splash = 'splash';
  static const String roleSelection = 'roleSelection';

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
  static const String postDetails = 'postDetails';

  // Owner Flow
  static const String ownerDashboard = 'ownerDashboard';
  static const String addRestaurant = 'addRestaurant';
  static const String editRestaurant = 'editRestaurant';
  static const String restaurantImages = 'restaurantImages';
  static const String addPost = 'addPost';
  static const String editPost = 'editPost';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    redirect: (BuildContext context, GoRouterState state) {
      final user = FirebaseAuth.instance.currentUser;
      final bool isLoggedIn = user != null;

      // Các trang công khai mà ai cũng có thể truy cập
      final publicPages = ['/splash', '/role-selection', '/login', '/register', '/forgot-password', '/owner-login', '/owner-register'];
      final isGoingToPublicPage = publicPages.contains(state.matchedLocation);

      // Kịch bản 1: Đã đăng nhập
      if (isLoggedIn) {
        final String role = (user.displayName != null && user.displayName!.startsWith('[OWNER]')) ? 'owner' : 'user';

        // Nếu đã đăng nhập và đang ở một trang công khai (ví dụ: vừa mở app, từ splash) -> chuyển hướng vào trong
        if (isGoingToPublicPage) {
          return role == 'owner' ? '/owner/dashboard' : '/';
        }
      }
      // Kịch bản 2: Chưa đăng nhập
      else {
        // Nếu chưa đăng nhập và cố gắng vào một trang cần đăng nhập -> đưa về trang chọn vai trò
        if (!isGoingToPublicPage) {
          return '/role-selection';
        }
      }

      // Các trường hợp khác (ví dụ: đã đăng nhập và đang ở trang home) -> không làm gì cả
      return null;
    },

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