import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/post_details/state/post_details_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../../../core/constants/colors.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailsCubit()..fetchPostDetails(postId),
      child: Scaffold(
        body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
          builder: (context, state) {
            if (state is PostDetailsLoading || state is PostDetailsInitial) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is PostDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is PostDetailsLoaded) {
              final post = state.postData;
              final DateTime createdAt = post['createdAt'];

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        post['title'],
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      background: Image.network(
                        post['coverImageUrl'],
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(kSpacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề đầy đủ
                          Text(
                            post['title'],
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          vSpaceM,
                          // Thông tin tác giả (nhà hàng)
                          InkWell(
                            onTap: () {
                              // Điều hướng đến trang chi tiết nhà hàng
                              context.pushNamed(
                                AppRouteNames.restaurantDetails,
                                pathParameters: {'restaurantId': post['restaurantId']},
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.storefront, color: Colors.grey),
                                hSpaceS,
                                Text(
                                  'Bởi ${post['restaurantName']}',
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                                ),
                                hSpaceM,
                                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                hSpaceXS,
                                Text(
                                  '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: kSpacingXL),
                          // Nội dung bài viết
                          Text(
                            post['content'],
                            style: const TextStyle(fontSize: 16, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}