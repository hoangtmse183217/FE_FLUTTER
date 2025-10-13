import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/owner_dashboard/state/post_management_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/post/post_management_card.dart';
import 'package:mumiappfood/routes/app_router.dart';

class PostManagementView extends StatelessWidget {
  const PostManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostManagementCubit()..fetchMyPosts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Quản lý Bài viết')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.pushNamed(AppRouteNames.addPost),
          icon: const Icon(Icons.add),
          label: const Text('Tạo bài viết mới'),
        ),
        body: BlocBuilder<PostManagementCubit, PostManagementState>(
          builder: (context, state) {
            if (state is PostManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PostManagementError) {
              return Center(child: Text(state.message));
            }
            if (state is PostManagementLoaded) {
              if (state.posts.isEmpty) {
                return const Center(child: Text('Bạn chưa có bài viết nào.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(kSpacingM),
                itemCount: state.posts.length,
                separatorBuilder: (context, index) => vSpaceM,
                itemBuilder: (context, index) {
                  return PostManagementCard(post: state.posts[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}