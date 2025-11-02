import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverShimmer extends StatelessWidget {
  const DiscoverShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn khi đang shimmer
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer cho thanh sắp xếp
            _buildShimmerRow([100, 80, 120, 90]),
            vSpaceL,

            // Shimmer cho danh sách nhà hàng
            ...List.generate(5, (_) => _buildRestaurantCardShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow(List<double> widths) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widths.length,
        separatorBuilder: (context, index) => hSpaceS,
        itemBuilder: (context, index) {
          return Container(
            width: widths[index],
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantCardShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          vSpaceS,
          Container(
            height: 20,
            width: 200,
            color: Colors.white,
          ),
          vSpaceS,
          Container(
            height: 16,
            width: 150,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
