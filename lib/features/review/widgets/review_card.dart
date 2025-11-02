import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/core/widgets/rating_bar.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Function(Review) onEdit;
  final Function(Review) onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeAgo = DateFormat.yMd().add_jm().format(review.createdAt);
    final User? user = review.user;

    void showOptions() {
      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Chỉnh sửa đánh giá'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  onEdit(review);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                title: Text('Xóa đánh giá', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  onDelete(review);
                },
              ),
            ],
          );
        },
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: kSpacingS),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: (user?.avatar == null || user!.avatar!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                hSpaceM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullname ?? 'Người dùng ẩn danh',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(timeAgo, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                hSpaceM,
                StaticRatingBar(rating: review.rating, itemSize: 16),
                
                // SỬA LỖI: Luôn dùng `review.userId` để so sánh và hiện menu thay vì nút
                FutureBuilder<int?>(
                  future: AuthService.getCurrentUserId(),
                  builder: (context, snapshot) {
                    final currentUserId = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.done &&
                        currentUserId != null &&
                        review.userId == currentUserId) {
                      return SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                          onPressed: showOptions,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            if (review.comment.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: kSpacingS),
                child: Text(review.comment, style: textTheme.bodyMedium),
              ),
            if (review.partnerReplyComment != null && review.partnerReplyComment!.isNotEmpty) ...[
              vSpaceM,
              Container(
                padding: const EdgeInsets.all(kSpacingS),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phản hồi từ chủ quán', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    vSpaceXS,
                    Text(review.partnerReplyComment!, style: textTheme.bodySmall),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
