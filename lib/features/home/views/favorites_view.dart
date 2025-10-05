import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/features/home/widgets/restaurant_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Chúng ta sẽ cung cấp FavoritesCubit ở cấp cao hơn để các trang khác cũng truy cập được
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà hàng yêu thích'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }

          if (state is FavoritesLoaded) {
            // Luồng phụ: Danh sách trống
            if (state.favoriteRestaurants.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(kSpacingL),
                  child: Text(
                    'Bạn chưa có nhà hàng yêu thích nào.\nHãy nhấn vào biểu tượng trái tim để thêm nhé!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Luồng chính: Hiển thị danh sách
            return ListView.separated(
              padding: const EdgeInsets.all(kSpacingM),
              itemCount: state.favoriteRestaurants.length,
              separatorBuilder: (context, index) => vSpaceM,
              itemBuilder: (context, index) {
                final restaurant = state.favoriteRestaurants[index];
                return RestaurantCard(
                  restaurantId: restaurant['id'],
                  name: restaurant['name'],
                  imageUrl: 'https://via.placeholder.com/300x150', // Dữ liệu ảnh giả
                  cuisine: 'Ẩm thực đa dạng',
                  rating: 4.5,
                  moods: const [], // Có thể bỏ trống ở đây
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}