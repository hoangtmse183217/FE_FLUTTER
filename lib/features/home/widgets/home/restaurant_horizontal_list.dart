import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/home/state/home_state.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:shimmer/shimmer.dart';

// Widget để hiển thị một danh sách nhà hàng theo chiều ngang, có xử lý các trạng thái
class RestaurantHorizontalList extends StatelessWidget {
  final HomeSectionStatus status;
  final List<Restaurant> restaurants;
  final String? errorMessage;
  final VoidCallback onRetry;

  const RestaurantHorizontalList({
    super.key,
    required this.status,
    required this.restaurants,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Widget này trả về một Sliver để có thể đặt trực tiếp trong CustomScrollView
    switch (status) {
      case HomeSectionStatus.loading:
      case HomeSectionStatus.initial:
        return _buildLoadingShimmer(context);

      case HomeSectionStatus.failure:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingM),
            child: AppErrorWidget(
              message: errorMessage ?? 'Không thể tải dữ liệu.',
              onRetry: onRetry,
              isMini: true, // Sử dụng phiên bản nhỏ gọn cho section ngang
            ),
          ),
        );

      case HomeSectionStatus.success:
        if (restaurants.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: Text('Không có nhà hàng nào được tìm thấy.'),
              ),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 280, // Chiều cao cố định cho danh sách ngang
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: RestaurantCard(restaurant: restaurants[index]),
                );
              },
              separatorBuilder: (context, index) => hSpaceM,
            ),
          ),
        );
    }
  }

  // Widget hiển thị hiệu ứng shimmer khi đang tải
  Widget _buildLoadingShimmer(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Hiển thị 3 card giả lập
            padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const _RestaurantCardShimmer(),
              );
            },
            separatorBuilder: (context, index) => hSpaceM,
          ),
        ),
      ),
    );
  }
}

// Card giả lập cho hiệu ứng shimmer
class _RestaurantCardShimmer extends StatelessWidget {
  const _RestaurantCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: kSpacingS),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 150, color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(kSpacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: double.infinity, color: Colors.white),
                vSpaceXS,
                Container(height: 14, width: MediaQuery.of(context).size.width * 0.5, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
