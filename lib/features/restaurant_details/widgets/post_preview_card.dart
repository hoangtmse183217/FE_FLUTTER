import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/routes/app_router.dart';

class PostPreviewCard extends StatelessWidget {
  final String title;
  final String coverImageUrl;
  final String author; // Tên nhà hàng
  final DateTime createdAt;
  final String postId;

  // SỬA LỖI: Xóa tham số onTap không được sử dụng
  const PostPreviewCard({
    super.key,
    required this.title,
    required this.coverImageUrl,
    required this.author,
    required this.createdAt,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // SỬA LỖI: Sử dụng DateFormat để định dạng ngày tháng
    final formattedDate = DateFormat.yMd('vi_VN').format(createdAt);

    return InkWell(
      onTap: () {
        if (postId.isNotEmpty) {
          context.pushNamed(
            AppRouteNames.postDetails,
            pathParameters: {'postId': postId},
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 280, // Chiều rộng cố định cho danh sách cuộn ngang
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                coverImageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                // SỬA LỖI: Thêm loadingBuilder để cải thiện UX
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (c, e, s) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
            vSpaceS,
            // Tiêu đề
            Text(
              title,
              // SỬA LỖI: Sử dụng TextTheme để nhất quán
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            vSpaceXS,
            // Tác giả và ngày đăng
            // TODO: Use AppLocalizations for 'By' and date format
            Text(
              'Bởi $author • $formattedDate',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
