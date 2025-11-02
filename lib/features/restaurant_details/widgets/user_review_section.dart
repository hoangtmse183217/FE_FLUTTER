import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';
import 'package:mumiappfood/features/review/widgets/review_card.dart';

class UserReviewSection extends StatelessWidget {
  final int? currentUserId;
  final double averageRating;
  final int totalReviews;
  final List<Review> reviews;
  final VoidCallback onWriteReview;
  final Function(Review) onEditReview;
  final Function(Review) onDeleteReview;

  const UserReviewSection({
    super.key,
    this.currentUserId,
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
    required this.onWriteReview,
    required this.onEditReview,
    required this.onDeleteReview,
  });

  @override
  Widget build(BuildContext context) {
    Review? myReview;
    final List<Review> otherReviews = [];

    for (final review in reviews) {
      if (currentUserId != null && review.userId == currentUserId) {
        myReview = review;
      } else {
        otherReviews.add(review);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingL, kSpacingM, kSpacingL),
      children: [
        _buildHeader(context, myReview),
        vSpaceM,
        
        if (myReview != null)
          _buildMyReviewSection(context, myReview),
        
        if (otherReviews.isNotEmpty)
          ...otherReviews.map((review) => ReviewCard(
                review: review,
                onEdit: onEditReview,
                onDelete: onDeleteReview,
              )).toList(),

        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: kSpacingXL),
            child: Center(
              child: Text(
                'Chưa có đánh giá nào. Hãy là người đầu tiên! ',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Review? myReview) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đánh giá & Nhận xét', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (totalReviews > 0)
                Text(
                  '$averageRating trên 5 sao ($totalReviews đánh giá)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
            ],
          ),
        ),
        // SỬA LỖI: Khôi phục lại nút với logic đúng
        TextButton(
          onPressed: () {
            if (myReview != null) {
              onEditReview(myReview);
            } else {
              onWriteReview();
            }
          },
          child: Text(myReview != null ? 'Sửa đánh giá' : 'Viết đánh giá'),
        ),
      ],
    );
  }

  Widget _buildMyReviewSection(BuildContext context, Review myReview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đánh giá của bạn',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        vSpaceS,
        Card(
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          ),
          child: ReviewCard(
            review: myReview,
            onEdit: onEditReview,
            onDelete: onDeleteReview,
          ),
        ),
        const Divider(height: kSpacingXL, thickness: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}
