import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

import '../../../routes/app_router.dart';

class PostPreviewCard extends StatelessWidget {
  final String title;
  final String coverImageUrl;
  final String author; // Tên nhà hàng
  final DateTime createdAt;
  final VoidCallback onTap;
  final String postId;

  const PostPreviewCard({
    super.key,
    required this.title,
    required this.coverImageUrl,
    required this.author,
    required this.createdAt,
    required this.onTap,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouteNames.postDetails,
          pathParameters: {'postId': postId},
        );
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
                errorBuilder: (c, e, s) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            vSpaceS,
            // Tiêu đề
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            vSpaceXS,
            // Tác giả và ngày đăng
            Text(
              'Bởi ${author} • ${createdAt.day}/${createdAt.month}/${createdAt.year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}