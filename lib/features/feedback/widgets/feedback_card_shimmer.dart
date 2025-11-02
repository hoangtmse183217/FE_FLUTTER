import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class FeedbackCardShimmer extends StatelessWidget {
  const FeedbackCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(kSpacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Placeholder
              Row(
                children: [
                  const CircleAvatar(radius: 24, backgroundColor: Colors.white),
                  hSpaceM,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 150, height: 18, color: Colors.white),
                        vSpaceXS,
                        Container(width: 100, height: 16, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              vSpaceM,
              // Comment Placeholder
              Container(width: double.infinity, height: 16, color: Colors.white),
              vSpaceS,
              Container(width: double.infinity, height: 16, color: Colors.white),
              vSpaceS,
              Container(width: MediaQuery.of(context).size.width * 0.4, height: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
