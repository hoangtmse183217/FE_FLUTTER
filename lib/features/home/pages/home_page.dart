import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/favorites/views/favorites_view.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/home/state/profile_cubit.dart';
import 'package:mumiappfood/features/home/views/discover_view.dart';
import 'package:mumiappfood/features/home/views/home_view.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_cubit.dart';

import '../../../core/constants/colors.dart';
import '../views/profile_view.dart';

// LỚP BỌC BÊN NGOÀI: Cung cấp tất cả các Cubit cần thiết cho các tab
class HomePage extends StatelessWidget {
  // SỬA ĐỔI: Thêm tham số để nhận index tab ban đầu
  final int? initialIndex;

  const HomePage({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SỬA LỖI: HomeCubit không cần cung cấp ở đây nữa vì HomeView tự cung cấp
        BlocProvider(create: (context) => FavoritesCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => RestaurantCubit()), 
      ],
      // SỬA ĐỔI: Truyền initialIndex xuống cho view con
      child: _HomePageView(initialIndex: initialIndex ?? 0),
    );
  }
}

// GIAO DIỆN CHÍNH: Quản lý Scaffold, BottomNavigationBar và các tab
class _HomePageView extends StatefulWidget {
  // SỬA ĐỔI: Nhận initialIndex từ widget cha
  final int initialIndex;
  const _HomePageView({required this.initialIndex});

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  late int _selectedIndex;

  // SỬA ĐỔI: Sử dụng initState để thiết lập giá trị ban đầu từ widget
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // SỬA LẠI THỨ TỰ: Trang chủ -> Khám phá -> Yêu thích -> Hồ sơ
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    DiscoverView(),
    FavoritesView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: break;
      case 1: break;
      case 2: context.read<FavoritesCubit>().fetchFavorites(); break;
      case 3: context.read<ProfileCubit>().loadProfile(); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      // TRẢ LẠI BOTTOM NAVIGATOR 4 MỤC NHƯ CŨ
      bottomNavigationBar: _AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// WIDGET BOTTOM NAVIGATION BAR ĐÃ ĐƯỢC TÙY CHỈNH
class _AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: ''),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey.shade500,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 5,
    );
  }
}
