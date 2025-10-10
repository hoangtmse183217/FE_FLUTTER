import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
// Tái sử dụng ReviewCard từ dashboard của owner
import 'package:mumiappfood/features/owner_dashboard/widgets/feedback/review_card.dart';

import '../../../core/constants/colors.dart';

class UserReviewSection extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  // Dữ liệu giả, sẽ được thay thế bằng dữ liệu từ Cubit
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onWriteReview;

  const UserReviewSection({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Đánh giá & Bình luận', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  vSpaceXS,
                  if (totalReviews > 0)
                    Text('$totalReviews đánh giá', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              TextButton.icon(
                onPressed: onWriteReview,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Viết đánh giá'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          vSpaceM,
          if (reviews.isEmpty)
            const Center(child: Text('Chưa có đánh giá nào. Hãy là người đầu tiên!'))
          else
          // Chỉ hiển thị 2 review đầu tiên, có thể thêm nút "Xem tất cả" sau
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length > 2 ? 2 : reviews.length,
              separatorBuilder: (_, __) => vSpaceM,
              itemBuilder: (context, index) {
                return ReviewCard(review: reviews[index]);
              },
            ),
        ],
      ),
    );
  }
}