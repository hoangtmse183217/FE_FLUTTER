import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/features/restaurant_details/state/restaurant_details_cubit.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_header.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_info_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_map_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/restaurant_posts_section.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/user_review_section.dart'; // <-- 1. Import
import 'package:mumiappfood/features/restaurant_details/widgets/write_review_sheet.dart';

import '../../../core/constants/colors.dart'; // <-- 1. Import

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  // --- HÀM MỚI ĐỂ XỬ LÝ VIỆC HIỂN THỊ BOTTOM SHEET ---
  void _showWriteReviewSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const WriteReviewSheet(),
    );

    // Xử lý kết quả trả về từ BottomSheet
    if (result != null && context.mounted) {
      // TODO: Gọi Cubit để gửi review lên server
      // context.read<RestaurantDetailsCubit>().submitReview(
      //   rating: result['rating'],
      //   comment: result['comment'],
      // );
      print('Review to be submitted: $result');
      AppSnackbar.showSuccess(context, 'Cảm ơn bạn đã gửi đánh giá!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailsCubit()..fetchRestaurantDetails(restaurantId),
      child: Scaffold(
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
              elevation: 4,
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
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is RestaurantDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is RestaurantDetailsLoaded) {
              final data = state.restaurantData;
              // Dữ liệu giả, sau này sẽ được lấy từ API/Cubit
              final postsData = [
                {
                  'id': 'post1',
                  'title': 'Khám phá thực đơn mùa thu mới của chúng tôi',
                  'coverImageUrl': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
                  'createdAt': DateTime.now().subtract(const Duration(days: 3)),
                },
                {
                  'id': 'post2',
                  'title': 'Đêm nhạc Acoustic thứ Bảy hàng tuần',
                  'coverImageUrl': 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=500',
                  'createdAt': DateTime.now().subtract(const Duration(days: 7)),
                },
                {
                  'id': 'post2',
                  'title': 'Đêm nhạc Acoustic thứ Bảy hàng tuần',
                  'coverImageUrl': 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=500',
                  'createdAt': DateTime.now().subtract(const Duration(days: 7)),
                }
              ];
              final reviewsData = [
                { 'userName': 'Văn A', 'userAvatarUrl': null, 'rating': 5.0, 'comment': 'Tuyệt vời!', 'createdAt': DateTime.now() },
                { 'userName': 'Văn A', 'userAvatarUrl': null, 'rating': 5.0, 'comment': 'Tuyệt vời!', 'createdAt': DateTime.now() },
                { 'userName': 'Văn A', 'userAvatarUrl': null, 'rating': 5.0, 'comment': 'Tuyệt vời!', 'createdAt': DateTime.now() },
                { 'userName': 'Văn A', 'userAvatarUrl': null, 'rating': 5.0, 'comment': 'Tuyệt vời!', 'createdAt': DateTime.now() },
              ];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    RestaurantHeader(
                      name: data['name'],
                      cuisine: data['cuisine'],
                      rating: data['rating'],
                      images: List<String>.from(data['images']),
                    ),
                    const SizedBox(height: 66),

                    // --- Thông tin chi tiết ---
                    RestaurantInfoSection(
                      description: data['description'],
                      address: data['address'],
                      priceRange: data['priceRange'],
                    ),
                    const Divider(height: kSpacingXL),

                    // --- Bản đồ ---
                    RestaurantMapSection(
                      latitude: data['latitude'],
                      longitude: data['longitude'],
                      restaurantName: data['name'],
                    ),
                    const Divider(height: kSpacingXL),

                    // --- Bài viết ---
                    RestaurantPostsSection(
                      posts: postsData,
                      restaurantName: data['name'],
                    ),
                    const Divider(height: kSpacingXL),

                    // --- 2. THÊM SECTION ĐÁNH GIÁ ---
                    UserReviewSection(
                      averageRating: data['rating'],
                      totalReviews: reviewsData.length,
                      reviews: reviewsData,
                      onWriteReview: () => _showWriteReviewSheet(context),
                    ),

                    vSpaceXL,
                    // Khoảng trống ở dưới cùng
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