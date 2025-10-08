import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/views/dashboard_home_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/feedback_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/owner_profile_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/restaurant_management_view.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';

import '../../../core/constants/colors.dart';

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int _selectedIndex = 0;

  static const List<Widget> _views = <Widget>[
    DashboardHomeView(),
    RestaurantManagementView(),
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
        // ========================================================
        // === APPBAR MỚI, ĐẸP HƠN & SÁT TRÁI ===
        // ========================================================
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0.8,
            automaticallyImplyLeading: false, // loại bỏ padding mặc định
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar (tùy chọn)
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        AppIcons.profile,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // --- Greeting + Name ---
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
                          Text(
                            firstName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // --- Notification button ---
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

        // === BODY ===
        body: IndexedStack(
          index: _selectedIndex,
          children: _views,
        ),

        // === BOTTOM NAV ===
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
