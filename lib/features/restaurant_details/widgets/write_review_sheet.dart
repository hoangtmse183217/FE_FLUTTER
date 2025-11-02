import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';

import '../../../core/widgets/app_textfield.dart';

class WriteReviewSheet extends StatefulWidget {
  const WriteReviewSheet({super.key});

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  double _rating = 0.0;
  final _commentController = TextEditingController();

  void _submitReview() {
    if (_rating == 0.0) {
      // SỬA ĐỔI: Sử dụng chuỗi cứng tiếng Việt
      AppSnackbar.showError(context, 'Vui lòng chọn số sao đánh giá.');
      return;
    }
    final reviewData = {
      'rating': _rating,
      'comment': _commentController.text.trim(),
    };
    Navigator.pop(context, reviewData);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, MediaQuery.of(context).viewInsets.bottom + kSpacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SỬA ĐỔI: Sử dụng chuỗi cứng tiếng Việt
          Text('Bạn đánh giá nhà hàng này thế nào?', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          vSpaceM,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  splashRadius: 20,
                );
              }),
            ),
          ),
          vSpaceL,
          AppTextField(
            controller: _commentController,
            // SỬA ĐỔI: Sử dụng chuỗi cứng tiếng Việt
            hintText: 'Chia sẻ cảm nhận của bạn về đồ ăn, không gian, phục vụ...',
            labelText: 'Bình luận (Tùy chọn)',
            maxLines: 4,
          ),
          vSpaceL,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              // SỬA ĐỔI: Sử dụng chuỗi cứng tiếng Việt
              text: 'Gửi đánh giá',
              onPressed: _submitReview,
            ),
          )
        ],
      ),
    );
  }
}
