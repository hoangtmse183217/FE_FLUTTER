import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/post_preview_card.dart';

class RestaurantPostsSection extends StatelessWidget {
  // Dữ liệu giả, sẽ được thay thế bằng dữ liệu từ Cubit
  final List<Map<String, dynamic>> posts;
  final String restaurantName;

  const RestaurantPostsSection({
    super.key,
    required this.posts,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      // Không hiển thị gì nếu không có bài viết
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kSpacingM),
          child: Text(
            'Câu chuyện & Tin tức',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        vSpaceM,
        SizedBox(
          height: 228,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
            itemCount: posts.length,
            separatorBuilder: (context, index) => hSpaceM,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostPreviewCard(
                postId: post['id'],
                title: post['title'],
                coverImageUrl: post['coverImageUrl'],
                author: restaurantName,
                createdAt: post['createdAt'],
                onTap: () {
                  // TODO: Điều hướng đến trang chi tiết bài viết
                  // context.pushNamed(AppRouteNames.postDetails, pathParameters: {'postId': post['id']});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}