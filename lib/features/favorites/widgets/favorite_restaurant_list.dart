import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import '../../home/widgets/home/restaurant_card.dart';

class FavoriteRestaurantList extends StatelessWidget {
  // SỬA LỖI: Nhận vào List<Restaurant> thay vì List<Map>
  final List<Restaurant> favoriteRestaurants;

  const FavoriteRestaurantList({
    super.key,
    required this.favoriteRestaurants,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic, possibly by calling the cubit
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(kSpacingM),
        itemCount: favoriteRestaurants.length,
        separatorBuilder: (context, index) => vSpaceM,
        itemBuilder: (context, index) {
          final restaurant = favoriteRestaurants[index];
          // SỬA LỖI: Truyền thẳng đối tượng Restaurant vào
          return RestaurantCard(restaurant: restaurant);
        },
      ),
    );
  }
}
