import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/restaurant_details/widgets/post_card.dart';

class RestaurantPostsSection extends StatelessWidget {
  final List<Post> posts;
  final String restaurantName;

  const RestaurantPostsSection({
    super.key,
    required this.posts,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(kSpacingL),
          child: Text(
            'Chưa có bài viết nào về nhà hàng này.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // SỬA LỖI: Chuyển thành ListView.builder để widget này tự xử lý việc cuộn,
    // loại bỏ xung đột với NestedScrollView.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingL, kSpacingM, kSpacingL),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}
