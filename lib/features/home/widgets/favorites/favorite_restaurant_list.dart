import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

import '../home/restaurant_card.dart';

class FavoriteRestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRestaurants;

  const FavoriteRestaurantList({
    super.key,
    required this.favoriteRestaurants,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(kSpacingM),
      itemCount: favoriteRestaurants.length,
      separatorBuilder: (context, index) => vSpaceM,
      itemBuilder: (context, index) {
        final restaurant = favoriteRestaurants[index];
        // Bạn có thể lấy thêm các trường dữ liệu thật từ 'restaurant' nếu có
        return RestaurantCard(
          restaurantId: restaurant['id'],
          name: restaurant['name'],
          // Thay thế bằng imageUrl thật từ dữ liệu của bạn
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
          cuisine: 'Ẩm thực đa dạng',
          rating: 4.5,
          moods: const [],
        );
      },
    );
  }
}