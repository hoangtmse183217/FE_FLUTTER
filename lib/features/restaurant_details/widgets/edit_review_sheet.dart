import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';

class EditReviewSheet extends StatefulWidget {
  final Review reviewToEdit;

  const EditReviewSheet({super.key, required this.reviewToEdit});

  @override
  State<EditReviewSheet> createState() => _EditReviewSheetState();
}

class _EditReviewSheetState extends State<EditReviewSheet> {
  late double _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.reviewToEdit.rating;
    _commentController = TextEditingController(text: widget.reviewToEdit.comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0) {
      // Validation có thể được thêm ở đây nếu cần
    }
    final result = {
      'rating': _rating,
      'comment': _commentController.text,
    };
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: kSpacingM,
        right: kSpacingM,
        top: kSpacingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chỉnh sửa đánh giá của bạn',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          vSpaceL,
          // SỬA LỖI: Tái sử dụng logic vẽ sao từ WriteReviewSheet
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
          TextField(
            controller: _commentController,
            maxLines: 4,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Chia sẻ cảm nhận của bạn...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          vSpaceL,
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cập nhật đánh giá'),
          ),
          vSpaceL,
        ],
      ),
    );
  }
}
