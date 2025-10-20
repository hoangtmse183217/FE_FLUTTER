import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';
import '../../../../l10n/app_localizations.dart';

class RestaurantCard extends StatelessWidget {
  final String restaurantId;
  final String name;
  final String imageUrl;
  final String cuisine;
  final double rating;
  final List<String> moods; // Expecting mood keys, e.g., ['family', 'romantic']

  const RestaurantCard({
    super.key,
    required this.restaurantId,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
    required this.moods,
  });

  String _getLocalizedMood(BuildContext context, String moodKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (moodKey) {
      case 'family':
        return localizations.family;
      case 'relaxing':
        return localizations.relaxing;
      case 'romantic':
        return localizations.romantic;
      case 'lively':
        return localizations.lively;
      case 'luxurious':
        return localizations.luxurious;
      case 'quick':
        return localizations.quick;
      case 'friends':
        return localizations.friends;
      default:
        return moodKey; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRouteNames.restaurantDetails,
            pathParameters: {'restaurantId': restaurantId},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 150, color: Colors.grey[300]),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      bool isFavorite = false;
                      if (state is FavoritesLoaded) {
                        isFavorite = state.favoriteIds.contains(restaurantId);
                      }
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(restaurantId);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
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
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  vSpaceXS,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cuisine,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          hSpaceXS,
                          Text(
                            rating.toString(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  vSpaceS,
                  if (moods.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: moods.map((moodKey) {
                        final localizedMood = _getLocalizedMood(context, moodKey);
                        return Chip(
                          label: Text(localizedMood),
                          padding: EdgeInsets.zero,
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
