import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Lớp này chứa tên của các routes để tránh lỗi gõ sai chuỗi.
class AppRouteNames {
  static const String home = 'home';
  static const String login = 'login';
  static const String recipeDetails = 'recipeDetails';
}

/// Lớp quản lý cấu hình GoRouter cho toàn bộ ứng dụng.
class AppRouter {
  // Tạo một instance của GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Route ban đầu khi mở ứng dụng
    debugLogDiagnostics: true, // Hiển thị log debug, tắt khi release

    // Danh sách tất cả các route của ứng dụng
    routes: <RouteBase>[
      // Route cho màn hình chính (Home)
      // GoRoute(
      //   path: '/',
      //   name: AppRouteNames.home,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const HomePage(); // Widget của màn hình Home
      //   },
      //   // Các route con của Home
      //   routes: <RouteBase>[
      //     // Route cho màn hình chi tiết món ăn
      //     // Dấu ':' cho biết 'id' là một tham số (parameter)
      //     GoRoute(
      //       path: 'recipe/:id', // ví dụ: /recipe/123
      //       name: AppRouteNames.recipeDetails,
      //       builder: (BuildContext context, GoRouterState state) {
      //         // Lấy tham số 'id' từ route
      //         final String recipeId = state.pathParameters['id']!;
      //         return RecipeDetailsPage(recipeId: recipeId);
      //       },
      //     ),
      //   ],
      // ),
      //
      // // Route cho màn hình đăng nhập
      // GoRoute(
      //   path: '/login',
      //   name: AppRouteNames.login,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const LoginPage(); // Widget của màn hình Login
      //   },
      // ),
    ],

    // Xử lý khi route không được tìm thấy
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Lỗi')),
      body: Center(child: Text('Không tìm thấy trang: ${state.error}')),
    ),
  );
}