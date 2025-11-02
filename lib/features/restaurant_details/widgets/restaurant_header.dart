import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RestaurantHeader extends StatefulWidget {
  // BẮT BUỘC: Thêm restaurantId
  final int restaurantId;
  final List<String> images;

  const RestaurantHeader({
    super.key,
    required this.restaurantId,
    required this.images,
  });

  @override
  State<RestaurantHeader> createState() => _RestaurantHeaderState();
}

class _RestaurantHeaderState extends State<RestaurantHeader> {
  int _currentPage = 0;

  // BẮT BUỘC: Sửa lại hàm để truyền tham số
  void _openPhotoView(BuildContext context, String imageUrl, String heroTag) {
    context.pushNamed(
      AppRouteNames.photoView,
      pathParameters: {
        'restaurantId': widget.restaurantId.toString(),
      },
      extra: {'imageUrl': imageUrl, 'heroTag': heroTag},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImageCarousel(context),
        if (widget.images.length > 1) _buildPageIndicator(),
      ],
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return widget.images.isEmpty
        ? Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
          )
        : PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, index) {
              final imageUrl = widget.images[index];
              final heroTag = 'restaurant_image_$imageUrl';

              return GestureDetector(
                onTap: () => _openPhotoView(context, imageUrl, heroTag),
                child: Hero(
                  tag: heroTag,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.6, 1.0],
                      ),
                    ),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.images.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            width: _currentPage == index ? 24.0 : 8.0,
            decoration: BoxDecoration(
              color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }
}
