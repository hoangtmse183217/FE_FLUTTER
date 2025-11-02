import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/post/data/models/comment_model.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/state/post_cubit.dart';
import 'package:mumiappfood/features/post/state/post_state.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';

class PostDetailsView extends StatefulWidget {
  final int postId;
  const PostDetailsView({super.key, required this.postId});

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPostDetails(widget.postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    context.read<PostCubit>().addComment(widget.postId, _commentController.text.trim());
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading && state is! PostDetailsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<PostCubit>().fetchPostDetails(widget.postId));
          }
          if (state is PostDetailsLoaded) {
            // SỬA LỖI: Truyền toàn bộ state vào hàm build
            return _buildPostContent(context, state);
          }
          return const Center(child: Text('Đang tải bài viết...'));
        },
      ),
      bottomNavigationBar: _buildCommentInputField(),
    );
  }

  // SỬA LỖI: Nhận vào PostDetailsLoaded state thay vì các tham số riêng lẻ
  Widget _buildPostContent(BuildContext context, PostDetailsLoaded state) {
    final Post post = state.post;
    final List<Comment> comments = state.comments;
    final User? author = state.author;
    final Restaurant? restaurant = state.restaurant;

    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMMMMd('vi_VN').add_jm().format(post.createdAt);

    final Widget placeholderImage = Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported_outlined, size: 80, color: Colors.grey),
    );

    // SỬA LỖI: Lấy thông tin tác giả từ state một cách an toàn
    final authorName = author?.fullname ?? 'Tác giả';
    final authorAvatar = author?.avatar;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          floating: false,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            title: Text(post.title, style: const TextStyle(fontSize: 16, color: Colors.white, shadows: [Shadow(blurRadius: 4, color: Colors.black54)]), maxLines: 1, overflow: TextOverflow.ellipsis),
            background: (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                ? Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => placeholderImage,
                  )
                : placeholderImage,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(kSpacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: (authorAvatar != null && authorAvatar.isNotEmpty) 
                          ? NetworkImage(authorAvatar) 
                          : null,
                      child: (authorAvatar == null || authorAvatar.isEmpty) 
                          ? const Icon(Icons.person) 
                          : null,
                    ),
                    hSpaceM,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authorName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(formattedDate, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                // SỬA LỖI: Hiển thị tên nhà hàng từ state
                if (restaurant != null) ...[
                  vSpaceM,
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined, size: 16, color: Colors.grey[600]),
                      hSpaceS,
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
                const Divider(height: kSpacingXL),
                Text(post.content, style: textTheme.bodyLarge?.copyWith(height: 1.5)),
                const Divider(height: kSpacingXL),
                Text('Bình luận (${comments.length})', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                vSpaceM,
              ],
            ),
          ),
        ),
        _buildCommentList(comments),
      ],
    );
  }

  Widget _buildCommentList(List<Comment> comments) {
    if (comments.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: kSpacingL),
            child: Text('Hãy là người đầu tiên bình luận!'),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
      sliver: SliverList.separated(
        itemCount: comments.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final comment = comments[index];
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
        },
      ),
    );
  }

  Widget _buildCommentInputField() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is! PostDetailsLoaded) return const SizedBox.shrink();
        
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(kSpacingM, kSpacingS, kSpacingM, MediaQuery.of(context).viewInsets.bottom + kSpacingS),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Viết bình luận...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingS),
                    ),
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                hSpaceM,
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
