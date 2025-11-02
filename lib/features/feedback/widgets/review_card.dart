import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/feedback/state/feedback_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCard extends StatefulWidget {
  final Map<String, dynamic> review;
  const ReviewCard({super.key, required this.review});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  final _replyController = TextEditingController();
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    // Nếu đã có reply, gán vào controller để tiện cho việc sửa
    final partnerReply = widget.review['partnerReplyComment'] as String?;
    if (partnerReply != null && partnerReply.isNotEmpty) {
      _replyController.text = partnerReply;
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply(BuildContext context) {
    if (_replyController.text.trim().isEmpty) return;

    final reviewId = widget.review['id'] as int?;
    if (reviewId == null) {
      AppSnackbar.showError(context, 'Lỗi: Không tìm thấy ID của đánh giá.');
      return;
    }

    context.read<FeedbackCubit>().replyToReview(reviewId, _replyController.text.trim());
    
    // Sau khi gửi, chỉ cần tắt chế độ trả lời
    setState(() => _isReplying = false);
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    final textTheme = Theme.of(context).textTheme;

    final user = widget.review['user'] as Map<String, dynamic>?;
    final userProfile = user?['profile'] as Map<String, dynamic>?;
    final rating = widget.review['rating'] as int? ?? 0;
    final partnerReply = widget.review['partnerReplyComment'] as String?;
    final hasReplied = partnerReply != null && partnerReply.isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, user, userProfile, rating, textTheme),
            vSpaceM,
            Text(widget.review['comment'] ?? 'Người dùng không để lại bình luận.', style: textTheme.bodyLarge),
            vSpaceM,
            // --- PHẦN PHẢN HỒI ---
            if (hasReplied && !_isReplying)
              _buildPartnerReply(context, partnerReply!, textTheme)
            else if (_isReplying)
              _buildReplyInput(context)
            else
              _buildReplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, Map<String, dynamic>? user, Map<String, dynamic>? profile, int rating, TextTheme textTheme) {
    final avatarUrl = profile?['avatar'] as String?;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    String reviewTimeAgo;
    try {
      final createdAt = widget.review['createdAt'] as String?;
      reviewTimeAgo = createdAt != null ? timeago.format(DateTime.parse(createdAt), locale: 'vi') : 'không rõ';
    } catch (_) {
      reviewTimeAgo = 'thời gian không hợp lệ';
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
          backgroundColor: AppColors.surface,
          child: !hasAvatar ? const Icon(Icons.person_outline, color: AppColors.textSecondary) : null,
        ),
        hSpaceM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?['fullname'] ?? 'Người dùng ẩn danh', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              vSpaceXS,
              Row(
                children: List.generate(5, (index) => Icon(
                  index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 20,
                )),
              ),
            ],
          ),
        ),
        Text(reviewTimeAgo, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildPartnerReply(BuildContext context, String reply, TextTheme textTheme) {
    String replyTimeAgo = '';
    try {
      final repliedAt = widget.review['partnerReplyAt'] as String?;
      replyTimeAgo = repliedAt != null ? timeago.format(DateTime.parse(repliedAt), locale: 'vi') : 'không rõ';
    } catch (_) {
      replyTimeAgo = 'thời gian không hợp lệ';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpacingM),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phản hồi của bạn:', style: textTheme.labelLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          vSpaceS,
          Text(reply, style: textTheme.bodyMedium),
          vSpaceS,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(replyTimeAgo, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              hSpaceS,
              InkWell(
                onTap: () => setState(() => _isReplying = true),
                child: const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReplyButton() {
    final partnerReply = widget.review['partnerReplyComment'] as String?;
    final bool hasReplied = partnerReply != null && partnerReply.isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => setState(() => _isReplying = true),
        icon: Icon(hasReplied ? Icons.edit_outlined : Icons.reply_outlined, size: 18),
        label: Text(hasReplied ? 'Chỉnh sửa phản hồi' : 'Trả lời'),
      ),
    );
  }
  
  Widget _buildReplyInput(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          autofocus: true,
          controller: _replyController,
          labelText: 'Nội dung trả lời',
          hintText: 'Nhập phản hồi của bạn...',
          maxLines: 3,
        ),
        vSpaceM,
        BlocBuilder<FeedbackCubit, FeedbackState>(
           builder: (context, state) {
            final bool isSubmitting = state is FeedbackLoaded && state.isReplying;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isSubmitting ? null : () => setState(() => _isReplying = false),
                  child: const Text('Hủy'),
                ),
                hSpaceS,
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => _submitReply(context),
                  child: isSubmitting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Gửi'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
