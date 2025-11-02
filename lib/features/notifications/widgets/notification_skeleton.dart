import 'package:flutter/material.dart';
import 'package:mumiappfood/core/widgets/skeleton.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

// Widget hiển thị khung chờ cho một item thông báo
class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: kSpacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(height: 48, width: 48, style: SkeletonStyle.circle),
          hSpaceM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: double.infinity, height: 16),
                vSpaceS,
                Skeleton(width: double.infinity, height: 14),
                vSpaceS,
                Skeleton(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
