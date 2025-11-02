import 'package:flutter/material.dart';

enum SkeletonStyle { rectangle, circle }

// Widget chung để hiển thị hiệu ứng khung chờ (shimmer effect)
class Skeleton extends StatefulWidget {
  final double? height;
  final double? width;
  final SkeletonStyle style;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.style = SkeletonStyle.rectangle,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: widget.style == SkeletonStyle.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.style == SkeletonStyle.rectangle ? BorderRadius.circular(8) : null,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [baseColor, highlightColor, baseColor],
          stops: [_animation.value - 0.5, _animation.value, _animation.value + 0.5],
        ),
      ),
    );
  }
}
