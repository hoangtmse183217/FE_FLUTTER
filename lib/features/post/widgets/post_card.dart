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
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN').format(post.createdAt);

    final Widget placeholderImage = Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Image.network(
                post.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => placeholderImage,
              )
            else
              placeholderImage,
            
            Padding(
              padding: const EdgeInsets.all(kSpacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.title,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  vSpaceS,
                  if (post.moods.isNotEmpty)
                    Wrap(
                      spacing: kSpacingS,
                      runSpacing: 4.0,
                      children: post.moods.map((mood) {
                        final moodName = (mood as Map<String, dynamic>)['name'] as String? ?? '';
                        return Chip(
                          label: Text(moodName),
                          labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor),
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide.none,
                        );
                      }).take(3).toList(),
                    ),
                  
                  vSpaceL,

                  // SỬA LỖI: Đã xóa thông tin nhà hàng không tồn tại.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ), 
      ),
    );
  }
}
