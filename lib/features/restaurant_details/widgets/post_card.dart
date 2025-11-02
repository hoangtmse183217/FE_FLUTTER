import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/routes/app_router.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat('dd/MM/yyyy').format(post.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: kSpacingM),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRouteNames.postDetails,
            pathParameters: {'postId': post.id.toString()},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Ảnh bìa ===
            AspectRatio(
              aspectRatio: 16 / 9,
              child: (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  ? Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                    )
                  : const DecoratedBox(
                      decoration: BoxDecoration(color: Color.fromARGB(255, 230, 230, 230)),
                      child: Icon(Icons.campaign, color: Colors.grey, size: 40),
                    ),
            ),

            // === Phần nội dung ===
            Padding(
              padding: const EdgeInsets.all(kSpacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SỬA ĐỔI: Tăng kích thước và độ đậm của tiêu đề
                  Text(
                    post.title,
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  vSpaceS,

                  // SỬA ĐỔI: Đưa ngày đăng lên ngay dưới tiêu đề
                  Text(
                    formattedDate,
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  vSpaceM,

                  // === Nội dung trích đoạn ===
                  Text(
                    post.content,
                    maxLines: 3, // Tăng thêm 1 dòng cho nội dung
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
