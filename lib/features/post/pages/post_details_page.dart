import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/post/data/models/comment_model.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/state/post_state.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../state/post_cubit.dart';

class PostDetailsPage extends StatelessWidget {
  final int postId;
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit()..fetchPostDetails(postId),
      child: _PostDetailsView(postId: postId),
    );
  }
}

class _PostDetailsView extends StatefulWidget {
  final int postId;
  const _PostDetailsView({required this.postId});

  @override
  State<_PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<_PostDetailsView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    final state = context.read<PostCubit>().state;
    if (state is PostDetailsLoaded) {
      context.read<PostCubit>().addComment(state.post.id, _commentController.text.trim());
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _openPhotoView(BuildContext context, String imageUrl, String heroTag) {
    final router = GoRouter.of(context);
    final location = router.namedLocation(
      AppRouteNames.postDetails,
      pathParameters: {'postId': widget.postId.toString()},
    ) + '/photo-view';

    context.push(location, extra: {'imageUrl': imageUrl, 'heroTag': heroTag});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostDetailsLoaded && state.commentErrorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.commentErrorMessage!)));
        }
      },
      builder: (context, state) {
        if (state is PostError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Có lỗi xảy ra')),
            body: AppErrorWidget(message: state.message, onRetry: () => context.read<PostCubit>().fetchPostDetails(widget.postId)),
          );
        }

        if (state is! PostDetailsLoaded) {
          return Scaffold(
            // SỬA LỖI: Bỏ tiêu đề, AppBar trong suốt
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true, // Giữ lại nút back
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final post = state.post;
        final textTheme = Theme.of(context).textTheme;
        final formattedDate = DateFormat.yMMMMd('vi_VN').add_jm().format(post.createdAt);

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              final placeholderImage = Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported_outlined, size: 80, color: Colors.grey),
              );
              final heroTag = 'post_image_${post.id}';

              return [
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  automaticallyImplyLeading: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
                              _openPhotoView(context, post.imageUrl!, heroTag);
                            }
                          },
                          child: Hero(
                            tag: heroTag,
                            child: (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                                ? Image.network(post.imageUrl!, fit: BoxFit.cover, errorBuilder: (c, e, s) => placeholderImage)
                                : placeholderImage,
                          ),
                        ),
                        Positioned(
                          bottom: kSpacingM,
                          left: kSpacingM,
                          right: kSpacingM,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(kSpacingM),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(post.title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                                  vSpaceS,
                                  Text(formattedDate, style: textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: _buildPostContent(context, state),
          ),
          bottomNavigationBar: _buildCommentInputField(state),
        );
      },
    );
  }

  Widget _buildPostContent(BuildContext context, PostDetailsLoaded state) {
    final Post post = state.post;
    final List<Comment> comments = state.comments;
    final bool isAddingComment = state.isAddingComment;
    final Restaurant? restaurant = state.restaurant;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(kSpacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.moods.isNotEmpty) ...[
                Wrap(
                  spacing: kSpacingS,
                  runSpacing: kSpacingS,
                  children: post.moods.map((mood) {
                    final moodName = (mood as Map<String, dynamic>)['name'] as String? ?? '';
                    return Chip(
                      label: Text(moodName),
                      labelStyle: textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: kSpacingS),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                vSpaceL,
              ],
              if (restaurant != null) ...[
                Row(
                  children: [
                    Icon(Icons.storefront_outlined, size: 16, color: Colors.grey[600]),
                    hSpaceS,
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: textTheme.bodySmall?.color),
                      ),
                    ),
                  ],
                ),
                const Divider(height: kSpacingXL),
              ],
              Text(post.content, style: textTheme.bodyLarge?.copyWith(height: 1.5)),
              const Divider(height: kSpacingXL),
              Text('Bình luận (${comments.length})', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              if (isAddingComment) ...[vSpaceM, const Center(child: CircularProgressIndicator())],
              vSpaceM,
            ],
          ),
        ),
        _buildCommentList(comments),
      ],
    );
  }

  Widget _buildCommentList(List<Comment> comments) {
    if (comments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: kSpacingL),
          child: Text('Hãy là người đầu tiên bình luận!'),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, 0, kSpacingM, kSpacingL),
      child: Column(
        children: comments.map((comment) {
          final authorName = comment.user?.fullname ?? 'Người dùng ẩn danh';
          final authorAvatar = comment.user?.avatar;
          final formattedDate = DateFormat.yMd('vi_VN').format(comment.createdAt);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: kSpacingS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (authorAvatar != null && authorAvatar.isNotEmpty) ? NetworkImage(authorAvatar) : null,
                  child: (authorAvatar == null || authorAvatar.isEmpty) ? const Icon(Icons.person) : null,
                ),
                hSpaceM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authorName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      vSpaceXS,
                      Text(comment.content),
                      vSpaceS,
                      Text(formattedDate, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommentInputField(PostDetailsLoaded state) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, MediaQuery.of(context).viewInsets.bottom + kSpacingS),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              hSpaceL,
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Thêm bình luận...',
                    border: InputBorder.none,
                  ),
                  enabled: !state.isAddingComment,
                  onSubmitted: (_) => _addComment(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                color: Theme.of(context).primaryColor,
                onPressed: state.isAddingComment ? null : _addComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
