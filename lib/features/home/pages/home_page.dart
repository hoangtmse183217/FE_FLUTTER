// lib/features/home/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/features/home/views/discover_view.dart';
import 'package:mumiappfood/features/home/views/favorites_view.dart';
import 'package:mumiappfood/features/home/views/home_view.dart';
import 'package:mumiappfood/features/home/views/profile_view.dart';

// HomePage giờ đây là một StatefulWidget đơn giản, chỉ có nhiệm vụ
// quản lý trạng thái của BottomNavigationBar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến state để theo dõi tab đang được chọn
  int _selectedIndex = 0;

  // Danh sách các widget view tương ứng với từng tab trên thanh điều hướng.
  // Thứ tự phải khớp với thứ tự của các item trong BottomNavigationBar.
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),        // Index 0
    DiscoverView(),    // Index 1
    FavoritesView(),   // Index 2
    ProfileView(),     // Index 3
  ];

  // Hàm được gọi khi người dùng nhấn vào một tab mới.
  void _onItemTapped(int index) {
    // Cập nhật lại state để build lại UI với trang mới.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Không còn BlocProvider ở đây nữa.
    return Scaffold(
      // Body của Scaffold sẽ hiển thị widget view được chọn từ danh sách.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // Thanh điều hướng ở dưới cùng.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.discover),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.favorite),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.profile),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Các thuộc tính để đảm bảo giao diện luôn đẹp và nhất quán
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // Luôn hiển thị label của các tab chưa được chọn
      ),
    );
  }
}