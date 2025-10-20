import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/features/home/views/discover_view.dart';
import 'package:mumiappfood/features/home/views/favorites_view.dart';
import 'package:mumiappfood/features/home/views/home_view.dart';
import 'package:mumiappfood/features/home/views/profile_view.dart';

import '../../../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(AppIcons.home),
            label: loc.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppIcons.discover),
            label: loc.discover,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppIcons.favorite),
            label: loc.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppIcons.profile),
            label: loc.myProfile,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
