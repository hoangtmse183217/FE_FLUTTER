import 'package:flutter/material.dart';

class StaticRatingBar extends StatelessWidget {
  final double rating;
  final double itemSize;
  final Color color;

  const StaticRatingBar({
    super.key,
    required this.rating,
    this.itemSize = 20.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon;
        // Logic để hiển thị sao đầy, sao nửa, hoặc sao rỗng
        if (index >= rating) {
          icon = Icons.star_border;
        } else if (index > rating - 1 && index < rating) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star;
        }
        return Icon(
          icon,
          size: itemSize,
          color: color,
        );
      }),
    );
  }
}
