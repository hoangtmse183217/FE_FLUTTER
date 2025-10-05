import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/features/restaurant_details/state/restaurant_details_cubit.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_header.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_info_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_map_section.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailsCubit()..fetchRestaurantDetails(restaurantId),
      child: Scaffold(
        // --- TÍCH HỢP NÚT YÊU THÍCH ---
        // 2. Thêm FloatingActionButton
        floatingActionButton: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            bool isFavorite = false;
            if (state is FavoritesLoaded) {
              isFavorite = state.favoriteIds.contains(restaurantId);
            }
            return FloatingActionButton(
              onPressed: () {
                context.read<FavoritesCubit>().toggleFavorite(restaurantId);
              },
              backgroundColor: isFavorite ? Colors.redAccent : Theme.of(context).primaryColor,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            );
          },
        ),
        body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
          builder: (context, state) {
            if (state is RestaurantDetailsLoading || state is RestaurantDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RestaurantDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is RestaurantDetailsLoaded) {
              final data = state.restaurantData;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RestaurantHeader(
                      name: data['name'],
                      cuisine: data['cuisine'],
                      rating: data['rating'],
                      images: List<String>.from(data['images']),
                    ),
                    const SizedBox(height: 66),
                    RestaurantInfoSection(
                      description: data['description'],
                      address: data['address'],
                      priceRange: data['priceRange'],
                    ),
                    const Divider(height: kSpacingXL),
                    RestaurantMapSection(
                      latitude: data['latitude'],
                      longitude: data['longitude'],
                      restaurantName: data['name'],
                    ),
                    vSpaceXL,
                    // Khoảng trống ở dưới cùng để FAB không che mất nội dung
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}