import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/features/home/widgets/favorites/empty_favorites.dart';
import 'package:mumiappfood/features/home/widgets/favorites/favorite_restaurant_list.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà hàng yêu thích'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          // Trạng thái Loading hoặc Initial
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // Trạng thái Lỗi
          if (state is FavoritesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Đã có lỗi xảy ra: ${state.message}'),
              ),
            );
          }

          // Trạng thái Tải xong
          if (state is FavoritesLoaded) {
            // Luồng phụ: Danh sách trống -> Sử dụng widget EmptyFavorites
            if (state.favoriteRestaurants.isEmpty) {
              return const EmptyFavorites();
            }

            // Luồng chính: Hiển thị danh sách -> Sử dụng widget FavoriteRestaurantList
            return FavoriteRestaurantList(
              favoriteRestaurants: state.favoriteRestaurants,
            );
          }

          // Trường hợp không xác định
          return const SizedBox.shrink();
        },
      ),
    );
  }
}