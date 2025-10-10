import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';

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
      // TODO: Hiển thị SnackBar yêu cầu chọn rating
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
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bạn đánh giá nhà hàng này thế nào?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceM,
          // --- Phần chọn sao ---
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
                );
              }),
            ),
          ),
          vSpaceM,
          // --- Phần nhập bình luận ---
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Chia sẻ cảm nhận của bạn về đồ ăn, không gian, phục vụ...',
              labelText: 'Bình luận (Tùy chọn)',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          vSpaceL,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Gửi đánh giá',
              onPressed: _submitReview,
            ),
          )
        ],
      ),
    );
  }
}