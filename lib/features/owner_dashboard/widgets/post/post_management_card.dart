import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/features/owner_dashboard/state/post_management_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostManagementCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostManagementCard({super.key, required this.post});

  // --- PRIVATE HELPERS ---

  ({Color color, String text}) _getStatusInfo() {
    final status = (post['status'] as String?)?.toLowerCase();
    switch (status) {
      case 'pending':
        return (color: Colors.orange.shade700, text: 'Chờ duyệt');
      case 'approved':
        return (color: Colors.green.shade700, text: 'Đã duyệt');
      case 'declined':
        return (color: Colors.red.shade700, text: 'Bị từ chối');
      default:
        return (color: Colors.grey, text: 'Không rõ');
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int postId, String postTitle) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa bài viết "$postTitle"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Hủy')),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PostManagementCubit>().deletePost(postId, postTitle);
    }
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          final postId = post['id'] as int?;
          if (postId == null) return;
          context.pushNamed(
            AppRouteNames.editPost,
            pathParameters: {'postId': postId.toString()},
          ).then((result) {
            if (result == true && context.mounted) {
              context.read<PostManagementCubit>().fetchMyPosts();
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWithStatus(context, _getStatusInfo()),
            _buildInfoPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithStatus(BuildContext context, ({Color color, String text}) statusInfo) {
    final String? imageUrl = post['imageUrl'] as String?;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: AppColors.surface,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.article, color: AppColors.textSecondary, size: 48)),
                  )
                : const Center(child: Icon(Icons.article, color: AppColors.textSecondary, size: 48)),
          ),
        ),
        Positioned(
          top: kSpacingS,
          right: kSpacingS,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusInfo.color,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Text(statusInfo.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final postTitle = post['title'] ?? 'Chưa có tiêu đề';

    return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingS, kSpacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postTitle,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                vSpaceXS,
                Text(
                  'Nhà hàng: ${post['restaurant']?['name'] ?? 'Không rõ'}',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Actions Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (value) {
              final postId = post['id'] as int?;
              if (postId == null) return;

              if (value == 'edit') {
                context.pushNamed(
                  AppRouteNames.editPost,
                  pathParameters: {'postId': postId.toString()},
                ).then((result) {
                  if (result == true && context.mounted) {
                    context.read<PostManagementCubit>().fetchMyPosts();
                  }
                });
              } else if (value == 'delete') {
                _showDeleteConfirmationDialog(context, postId, postTitle);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(value: 'edit', child: Text('Sửa bài viết')),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Xóa', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
