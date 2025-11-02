import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/features/auth/pages/forgot_password_page.dart';
import 'package:mumiappfood/features/auth/pages/login_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_forgot_password_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_login_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_register_page.dart';
import 'package:mumiappfood/features/auth/pages/owner/owner_reset_password_page.dart';
import 'package:mumiappfood/features/auth/pages/register_page.dart';
import 'package:mumiappfood/features/auth/pages/reset_password_page.dart';
import 'package:mumiappfood/features/chat/pages/chat_page.dart';
import 'package:mumiappfood/features/home/pages/home_page.dart';
import 'package:mumiappfood/features/notifications/pages/notifications_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_post_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/add_edit_restaurant_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/map_picker_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/owner_dashboard_page.dart';
import 'package:mumiappfood/features/owner_dashboard/pages/restaurant_images_page.dart';
import 'package:mumiappfood/features/photo_viewer/pages/photo_view_page.dart';
import 'package:mumiappfood/features/post/pages/post_details_page.dart';
import 'package:mumiappfood/features/post/pages/post_feed_page.dart';
import 'package:mumiappfood/features/restaurant_details/pages/restaurant_details_page.dart';
import 'package:mumiappfood/features/role_selection/pages/role_selection_page.dart';
import 'package:mumiappfood/features/splash/pages/splash_page.dart';

class AppRouteNames {
  static const String splash = 'splash';
  static const String roleSelection = 'roleSelection';

  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';

  static const String ownerLogin = 'ownerLogin';
  static const String ownerRegister = 'ownerRegister';
  static const String ownerForgotPassword = 'ownerForgotPassword';
  static const String ownerResetPassword = 'ownerResetPassword';

  // User Flow
  static const String home = 'home';
  static const String discover = 'discover'; // THÊM TÊN ROUTE BỊ THIẾU
  static const String restaurantDetails = 'restaurantDetails';
  static const String notifications = 'notifications';
  static const String postFeed = 'postFeed';
  static const String postDetails = 'postDetails';
  static const String photoView = 'photoView';
  static const String aiChat = 'aiChat';

  // Owner Flow
  static const String ownerDashboard = 'ownerDashboard';
  static const String addRestaurant = 'addRestaurant';
  static const String editRestaurant = 'editRestaurant';
  static const String restaurantImages = 'restaurantImages';
  static const String addPost = 'addPost';
  static const String editPost = 'editPost';
  static const String mapPicker = 'mapPicker';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final accessToken = await AuthService.getAccessToken();
      final isLoggedIn = accessToken != null && !JwtDecoder.isExpired(accessToken);

      final currentLocation = state.matchedLocation;

      final authRoutes = [
        '/role-selection',
        '/login',
        '/register',
        '/forgot-password',
        '/reset-password',
        '/owner-login',
        '/owner-register',
        '/owner-forgot-password',
        '/owner-reset-password',
      ];
      final isAnAuthRoute = authRoutes.contains(currentLocation);

      if (currentLocation == '/splash') {
        return null;
      }

      if (isLoggedIn) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
        final String role = (decodedToken['role'] as String?)?.toLowerCase() ?? 'user';

        if (role == 'partner' || role == 'owner') {
          final isAtUserArea = currentLocation == '/' ||
              currentLocation.startsWith('/restaurant') ||
              currentLocation.startsWith('/post');

          if (isAnAuthRoute || isAtUserArea) {
            return '/owner/dashboard';
          }
        } else {
          final isAtOwnerArea = currentLocation.startsWith('/owner');
          if (isAnAuthRoute || isAtOwnerArea) {
            return '/';
          }
        }
      } else {
        if (!isAnAuthRoute && currentLocation != '/splash') {
          return '/role-selection';
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/splash', name: AppRouteNames.splash, builder: (c, s) => const SplashPage()),
      GoRoute(path: '/role-selection', name: AppRouteNames.roleSelection, builder: (c, s) => const RoleSelectionPage()),

      // Auth Routes
      GoRoute(path: '/login', name: AppRouteNames.login, builder: (c, s) => const LoginPage()),
      GoRoute(path: '/register', name: AppRouteNames.register, builder: (c, s) => const RegisterPage()),
      GoRoute(path: '/forgot-password', name: AppRouteNames.forgotPassword, builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/owner-login', name: AppRouteNames.ownerLogin, builder: (c, s) => const OwnerLoginPage()),
      GoRoute(path: '/owner-register', name: AppRouteNames.ownerRegister, builder: (c, s) => const OwnerRegisterPage()),
      GoRoute(
        path: '/reset-password',
        name: AppRouteNames.resetPassword,
        builder: (context, state) {
          final Map<String, String> data = state.extra as Map<String, String>;
          return ResetPasswordPage(email: data['email']!, token: data['token']!);
        },
      ),

      // Owner Auth Routes
      GoRoute(
        path: '/owner-forgot-password',
        name: AppRouteNames.ownerForgotPassword,
        builder: (c, s) => const OwnerForgotPasswordPage(),
      ),
      GoRoute(
        path: '/owner-reset-password',
        name: AppRouteNames.ownerResetPassword,
        builder: (context, state) {
          final data = state.extra as Map<String, String>;
          return OwnerResetPasswordPage(email: data['email']!, token: data['token']!);
        },
      ),

      // User Flow Routes
      GoRoute(
        path: '/',
        name: AppRouteNames.home,
        builder: (c, s) => const HomePage(),
        routes: [
          // SỬA ĐỔI: Thêm route cho discover
          GoRoute(path: 'discover', name: AppRouteNames.discover, builder: (c, s) => const HomePage(initialIndex: 1)),
          GoRoute(
            path: 'restaurant/:restaurantId',
            name: AppRouteNames.restaurantDetails,
            builder: (context, state) {
              final id = state.pathParameters['restaurantId']!;
              return RestaurantDetailsPage(restaurantId: id);
            },
            routes: [
              GoRoute(
                  path: 'photo-view',
                  name: AppRouteNames.photoView,
                  builder: (context, state) {
                    final data = state.extra as Map<String, String>;
                    return PhotoViewPage(imageUrl: data['imageUrl']!, heroTag: data['heroTag']!);
                  }),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        name: AppRouteNames.notifications,
        builder: (c, s) => const NotificationsPage(),
      ),
       // THÊM GO_ROUTE MỚI CHO CHAT
      GoRoute(
        path: '/chat',
        name: AppRouteNames.aiChat,
        builder: (c, s) => const ChatPage(),
      ),
      GoRoute(
        path: '/posts',
        name: AppRouteNames.postFeed,
        builder: (c, s) => const PostFeedPage(),
      ),
      GoRoute(
        path: '/post/:postId',
        name: AppRouteNames.postDetails,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['postId']!);
          return PostDetailsPage(postId: id);
        },
        routes: [
          GoRoute(
              path: 'photo-view',
              builder: (context, state) {
                final data = state.extra as Map<String, String>;
                return PhotoViewPage(imageUrl: data['imageUrl']!, heroTag: data['heroTag']!);
              }),
        ],
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
        path: '/map-picker',
        name: AppRouteNames.mapPicker,
        builder: (context, state) => const MapPickerPage(),
      ),
    ],
  );
}
