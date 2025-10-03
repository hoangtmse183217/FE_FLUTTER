import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacingL),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacingS),
            child: Text(
              'hoặc tiếp tục với',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}