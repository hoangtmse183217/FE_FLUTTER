import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/features/feedback/state/feedback_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/state/post_management_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/views/dashboard_home_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/feedback_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/owner_profile_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/post_management_view.dart';
import 'package:mumiappfood/features/owner_dashboard/views/restaurant_management_view.dart';
import 'package:mumiappfood/routes/app_router.dart';


class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OwnerDashboardCubit()..fetchDashboardData()),
        // SỬA LỖI: Gọi fetchMyPosts() ngay khi tạo cubit
        BlocProvider(create: (_) => PostManagementCubit()..fetchMyPosts()),
        BlocProvider(create: (_) => FeedbackCubit()),
      ],
      child: const _OwnerDashboardView(),
    );
  }
}


class _OwnerDashboardView extends StatefulWidget {
  const _OwnerDashboardView();

  @override
  State<_OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<_OwnerDashboardView> {
  int _selectedIndex = 0;

  static const List<String> _pageTitles = [
    'Tổng quan',
    'Quản lý Nhà hàng',
    'Quản lý Bài viết',
    'Phản hồi & Đánh giá',
    'Hồ sơ'
  ];

  void _onItemTapped(int index) {
    // Luôn fetch lại dữ liệu khi người dùng chủ động chọn tab
    _refreshDataForTab(index);
    
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _refreshDataForTab(int index) {
     switch (index) {
      case 0:
        context.read<OwnerDashboardCubit>().refreshData();
        break;
      case 1:
        context.read<OwnerDashboardCubit>().refreshRestaurants();
        break;
      case 2:
        // SỬA LỖI: Đảm bảo gọi đúng hàm fetch của cubit
        context.read<PostManagementCubit>().fetchMyPosts(); 
        break;
      case 3:
        context.read<FeedbackCubit>().fetchInitialData();
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> views = <Widget>[
      DashboardHomeView(onNavigate: (tabIndex) => _onItemTapped(tabIndex)),
      const RestaurantManagementView(),
      const PostManagementView(),
      const FeedbackView(),
      const OwnerProfileView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0.8,
        toolbarHeight: _selectedIndex == 4 ? 0 : kToolbarHeight,
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notification, color: AppColors.textPrimary),
            onPressed: () => context.pushNamed(AppRouteNames.notifications),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), activeIcon: Icon(Icons.store), label: 'Nhà hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), activeIcon: Icon(Icons.article), label: 'Bài viết'),
          BottomNavigationBarItem(icon: Icon(Icons.reviews_outlined), activeIcon: Icon(Icons.reviews), label: 'Phản hồi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
