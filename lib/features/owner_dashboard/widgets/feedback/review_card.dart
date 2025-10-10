import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:timeago/timeago.dart' as timeago; // Thêm gói timeago: flutter pub add timeago

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({super.key, required this.review});

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userName = review['userName'];
    final String? userAvatarUrl = review['userAvatarUrl'];
    final double rating = review['rating'];
    final String comment = review['comment'];
    final DateTime createdAt = review['createdAt'];

    // Cấu hình timeago cho tiếng Việt
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Phần Header ---
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: userAvatarUrl != null ? NetworkImage(userAvatarUrl) : null,
                  child: userAvatarUrl == null ? Text(userName.substring(0, 1).toUpperCase()) : null,
                ),
                hSpaceM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      vSpaceXS,
                      Text(
                        timeago.format(createdAt, locale: 'vi'), // Hiển thị "5 giờ trước", "2 ngày trước"
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildRatingStars(rating),
              ],
            ),
            vSpaceM,
            // --- Phần Bình luận ---
            Text(
              comment,
              style: TextStyle(color: Colors.grey[800], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}