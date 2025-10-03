import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';


class AuthModeSwitcher extends StatelessWidget {
  final String label;
  final String actionText;
  final VoidCallback onPressed;

  const AuthModeSwitcher({
    super.key,
    required this.label,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSpaceM,
        const Divider(),
        vSpaceM,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            TextButton(
              onPressed: onPressed,
              child: Text(actionText),
            ),
          ],
        ),
      ],
    );
  }
}