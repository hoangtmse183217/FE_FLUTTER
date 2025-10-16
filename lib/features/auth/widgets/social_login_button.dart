import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mumiappfood/core/constants/colors.dart';

import '../../../core/constants/app_spacing.dart';


class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(iconPath, width: 24, height: 24),
        label: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: kSpacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}