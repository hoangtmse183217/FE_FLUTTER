import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacingL),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacingM), // Tăng khoảng cách
            child: Text(
              'hoặc',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        ],
      ),
    );
  }
}
