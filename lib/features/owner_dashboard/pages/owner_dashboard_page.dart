import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/views/dashboard_home_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/feedback_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/owner_profile_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/post_management_view.dart'; // <-- 1. Import PostManagementView
import 'package:mumiappfood/features/owner_dashboard/views/restaurant_management_view.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int _selectedIndex = 0;

  // 2. CẬP NHẬT DANH SÁCH VIEW - THÊM PostManagementView
  static const List<Widget> _views = <Widget>[
    DashboardHomeView(),
    RestaurantManagementView(),
    PostManagementView(), // <-- Thêm vào vị trí thứ 3
    FeedbackView(),
    OwnerProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Đối tác';
    final firstName = userName.replaceFirst('[OWNER] ', '').split(' ').first;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OwnerDashboardCubit()..fetchMyRestaurants(),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0.8,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(AppIcons.profile, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getGreeting(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          // Thêm lại tên người dùng
                          Text(
                            firstName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(AppIcons.notification, color: AppColors.textPrimary),
                      onPressed: () {
                        context.pushNamed(AppRouteNames.notifications);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _views,
        ),
        // 3. CẬP NHẬT BOTTOM NAVIGATION BAR - THÊM ITEM "BÀI VIẾT"
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedFontSize: 12, // Điều chỉnh kích thước font cho gọn
          unselectedFontSize: 12,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Tổng quan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Nhà hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Bài viết',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews_outlined),
              activeIcon: Icon(Icons.reviews),
              label: 'Phản hồi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }
}