import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/models/sort_option.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/favorites/widgets/empty_favorites.dart';
import 'package:mumiappfood/features/home/widgets/discover/discover_shimmer.dart';
import 'package:mumiappfood/features/home/widgets/discover/sort_selection_widget.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà hàng yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      // SỬA LỖI: Xóa BlocProvider cục bộ, sử dụng Cubit được chia sẻ
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          // Nếu Cubit chưa được khởi tạo, hãy fetch dữ liệu lần đầu
          // Điều này chỉ xảy ra một lần trong suốt vòng đời của app
          if (state.status == FavoritesStatus.initial) {
            context.read<FavoritesCubit>().fetchFavorites();
          }

          return Column(
            children: [
              SortSelectionWidget(
                activeSort: state.activeSort,
                onSortChanged: (sortOption) {
                  context.read<FavoritesCubit>().applySort(sortOption);
                },
                disabledOptions: const {SortOption.distance},
              ),
              const Divider(height: 1),
              Expanded(
                child: _buildContent(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoritesState state) {
    // Hiển thị shimmer khi đang fetch lần đầu
    if (state.status == FavoritesStatus.loading && state.originalFavorites.isEmpty) {
      return const DiscoverShimmer();
    }

    if (state.status == FavoritesStatus.failure) {
      return AppErrorWidget(
        message: state.errorMessage ?? 'Đã có lỗi xảy ra',
        onRetry: () => context.read<FavoritesCubit>().fetchFavorites(),
      );
    }

    // Nếu không có nhà hàng nào, hiển thị màn hình trống
    if (state.displayedFavorites.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<FavoritesCubit>().fetchFavorites(),
        child: Stack(
          children: [
            ListView(), // Widget rỗng để RefreshIndicator hoạt động
            const Center(child: EmptyFavorites()),
          ],
        ),
      );
    }

    // Hiển thị danh sách
    return RefreshIndicator(
      onRefresh: () => context.read<FavoritesCubit>().fetchFavorites(),
      child: ListView.separated(
        padding: const EdgeInsets.all(kSpacingM),
        itemCount: state.displayedFavorites.length,
        itemBuilder: (context, index) {
          final restaurant = state.displayedFavorites[index];
          return RestaurantCard(restaurant: restaurant);
        },
        separatorBuilder: (context, index) => vSpaceM,
      ),
    );
  }
}
