import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- 1. Import GoRouter

class RestaurantHeader extends StatelessWidget {
  final String name;
  final String cuisine;
  final double rating;
  final List<String> images;

  const RestaurantHeader({
    super.key,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Carousel hình ảnh
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(images[index], fit: BoxFit.cover);
            },
          ),
        ),
        // Nút back
        Positioned(
          top: 40, // Hoặc MediaQuery.of(context).padding.top để an toàn hơn
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              // 2. SỬA LẠI HÀNH ĐỘNG onPressed
              onPressed: () => context.pop(),
            ),
          ),
        ),
        // Thẻ thông tin
        Positioned(
          bottom: -50,
          left: 16,
          right: 16,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 20),
                      const SizedBox(width: 4),
                      Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Text(cuisine, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}