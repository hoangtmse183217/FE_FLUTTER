import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
        height: 150,
        color: Colors.grey[300],
        child: const Icon(Icons.storefront, color: Colors.grey, size: 50),
    );

    final String? imageUrl = restaurant.images.isNotEmpty ? restaurant.images.first.imageUrl : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingS),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRouteNames.restaurantDetails,
            pathParameters: {'restaurantId': restaurant.id.toString()},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => placeholder, 
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : placeholder, 
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      // SỬA LỖI: Truy cập trực tiếp state.favoriteIds, không cần check `is FavoritesLoaded`
                      bool isFavorite = state.favoriteIds.contains(restaurant.id);
                      return GestureDetector(
                        // NÂNG CẤP: Truyền cả restaurant object để tối ưu UI
                        onTap: () => context.read<FavoritesCubit>().toggleFavorite(restaurant.id, restaurant: restaurant),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(kSpacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  vSpaceXS,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(restaurant.moods.isNotEmpty ? restaurant.moods.join(', ') : restaurant.address, style: TextStyle(fontSize: 14, color: Colors.grey[600]), overflow: TextOverflow.ellipsis)),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          hSpaceXS,
                          Text(restaurant.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  if (restaurant.moods.isNotEmpty)...[
                     vSpaceS,
                     SizedBox(
                      height: 30,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurant.moods.length,
                        separatorBuilder: (_, __) => hSpaceS,
                        itemBuilder: (context, index) {
                          return Chip(
                            label: Text(restaurant.moods[index]),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
