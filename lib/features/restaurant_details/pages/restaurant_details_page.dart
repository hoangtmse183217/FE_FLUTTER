import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant_details/state/restaurant_details_cubit.dart';
import 'package:mumiappfood/features/restaurant_details/state/restaurant_details_state.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/edit_review_sheet.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_header.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_info_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_map_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_posts_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/user_review_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/write_review_sheet.dart';
import 'package:mumiappfood/features/review/data/repositories/review_repository.dart';
import 'package:mumiappfood/features/review/state/review_cubit.dart';
import 'package:mumiappfood/features/review/state/review_state.dart';

import '../../../core/constants/colors.dart';
import '../../../features/review/data/models/review_model.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  void _showWriteReviewSheet(BuildContext context, int currentRestaurantId) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const WriteReviewSheet(),
    );

    if (result != null && context.mounted) {
      final double rating = result['rating'] ?? 0.0;
      final String comment = result['comment'] ?? '';
      context.read<ReviewCubit>().submitReview(
            restaurantId: currentRestaurantId,
            rating: rating,
            comment: comment,
          );
    }
  }

  void _showEditReviewSheet(BuildContext context, Review reviewToEdit) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditReviewSheet(reviewToEdit: reviewToEdit),
    );

    if (result != null && context.mounted) {
      final double rating = result['rating'] ?? 0.0;
      final String comment = result['comment'] ?? '';
      context.read<ReviewCubit>().updateReview(
            reviewId: reviewToEdit.id,
            rating: rating,
            comment: comment,
            restaurantId: reviewToEdit.restaurantId,
          );
    }
  }

  void _confirmDeleteReview(BuildContext context, Review reviewToDelete) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa đánh giá này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Xóa', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ReviewCubit>().deleteReview(reviewToDelete.id, reviewToDelete.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int parsedRestaurantId = int.tryParse(restaurantId) ?? 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RestaurantDetailsCubit()..fetchRestaurantDetails(restaurantId),
        ),
        BlocProvider(
          // SỬA LỖI TRIỆT ĐỂ: Xóa bỏ AuthCubit không tồn tại
          create: (context) => ReviewCubit(ReviewRepository())..fetchReviews(parsedRestaurantId),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
            builder: (context, detailsState) {
              final canFavorite = detailsState is RestaurantDetailsLoaded;
              final Restaurant? restaurant = canFavorite ? detailsState.restaurant : null;

              return BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, favoritesState) {
                  final isFavorite = favoritesState.favoriteIds.contains(parsedRestaurantId);

                  return FloatingActionButton(
                    onPressed: canFavorite ? () => context.read<FavoritesCubit>().toggleFavorite(parsedRestaurantId, restaurant: restaurant) : null,
                    backgroundColor: canFavorite ? (isFavorite ? Colors.redAccent : Theme.of(context).primaryColor) : Colors.grey,
                    elevation: 4,
                    child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                  );
                },
              );
            },
          ),
          body: FutureBuilder<int?>(
            future: AuthService.getCurrentUserId(),
            builder: (context, userSnapshot) {
              final currentUserId = userSnapshot.data;

              return BlocListener<ReviewCubit, ReviewState>(
                listener: (context, state) {
                  if (state is ReviewSubmitSuccess || state is ReviewUpdateSuccess) {
                    AppSnackbar.showSuccess(context, 'Thao tác thành công!');
                  } else if (state is ReviewError || state is ReviewSubmitError || state is ReviewUpdateError) {
                    final errorMessage = state is ReviewError
                        ? state.message
                        : state is ReviewSubmitError
                            ? state.message
                            : (state as ReviewUpdateError).message;
                    AppSnackbar.showError(context, errorMessage);
                  }
                },
                child: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
                  builder: (context, detailsState) {
                    if (detailsState is RestaurantDetailsLoading || detailsState is RestaurantDetailsInitial) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }
                    if (detailsState is RestaurantDetailsError) {
                      return Center(child: Text(detailsState.message));
                    }
                    if (detailsState is RestaurantDetailsLoaded) {
                      final restaurant = detailsState.restaurant;
                      return NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          SliverAppBar(
                            expandedHeight: 280.0,
                            floating: false,
                            pinned: true,
                            elevation: 2,
                            flexibleSpace: FlexibleSpaceBar(
                              background: RestaurantHeader(restaurantId: restaurant.id, images: restaurant.images.map((e) => e.imageUrl).toList()),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                tabs: const [Tab(text: 'Tổng quan'), Tab(text: 'Bài viết'), Tab(text: 'Đánh giá')],
                              ),
                            ),
                            pinned: true,
                          ),
                        ],
                        body: TabBarView(
                          children: [
                            RestaurantInfoSection(
                              description: restaurant.description, 
                              address: restaurant.address, 
                              priceRange: restaurant.avgPrice,
                            ),
                            RestaurantPostsSection(posts: detailsState.posts, restaurantName: restaurant.name),
                            BlocBuilder<ReviewCubit, ReviewState>(
                              builder: (context, reviewState) {
                                if (reviewState is ReviewsLoaded) {
                                  return UserReviewSection(
                                    currentUserId: currentUserId,
                                    averageRating: restaurant.rating,
                                    totalReviews: reviewState.reviews.length,
                                    reviews: reviewState.reviews,
                                    onWriteReview: () => _showWriteReviewSheet(context, restaurant.id),
                                    onEditReview: (review) => _showEditReviewSheet(context, review),
                                    onDeleteReview: (review) => _confirmDeleteReview(context, review),
                                  );
                                }
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
