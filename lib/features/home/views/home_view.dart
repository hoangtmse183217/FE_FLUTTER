import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/widgets/home/location_display.dart';
import 'package:mumiappfood/features/home/widgets/home/location_selection_sheet.dart';
import 'package:mumiappfood/features/home/widgets/home/mood_selector.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';
import 'package:mumiappfood/features/home/widgets/home/section_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _currentLocation = 'Chọn vị trí của bạn';

  void _showLocationPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const LocationSelectionSheet();
      },
    );

    if (result != null && result.isNotEmpty) {
      if (result == 'manual_input') {
        // TODO: Handle manual input navigation
        // final manualAddress = await context.pushNamed<String>(...);
        // if (manualAddress != null) setState(() => _currentLocation = manualAddress);
      } else {
        setState(() {
          _currentLocation = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy tên người dùng từ Firebase Auth
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Bạn';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: kSpacingM),
          child: LocationDisplay(
            location: _currentLocation,
            onTap: _showLocationPicker,
          ),
        ),
        leadingWidth: 250,
        title: const Text(''),
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Phần Chào Mừng ---
            Text(
              'Xin chào, $userName!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            vSpaceS,
            const Text(
              'Bạn cảm thấy thế nào hôm nay?',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            vSpaceM,

            // --- Phần Chọn Mood ---
            const MoodSelector(),
            vSpaceL,

            // --- Phần Gợi Ý ---
            SectionHeader(title: 'Gợi ý nổi bật', onSeeAll: () {
              // TODO: Điều hướng sang trang Khám phá
            }),
            vSpaceM,

            // --- Danh sách Nhà hàng Gợi ý ---
            // Phần này có thể hiển thị các nhà hàng được quảng cáo
            // hoặc các nhà hàng có rating cao nhất gần vị trí của người dùng.
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2, // Dữ liệu giả
              separatorBuilder: (context, index) => vSpaceM,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurantId: 'home-suggestion-${index + 1}',
                  name: index == 0 ? 'Cuc Gach Quan' : 'Pizza 4P\'s',
                  imageUrl: index == 0
                      ? 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=500'
                      : 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
                  cuisine: index == 0 ? 'Món Việt' : 'Pizza & Mì Ý',
                  rating: index == 0 ? 4.8 : 4.9,
                  moods: index == 0 ? const ['Gia đình', 'Thư giãn'] : const ['Gia đình', 'Lãng mạn'],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}