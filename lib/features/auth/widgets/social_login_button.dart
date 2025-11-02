import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30), // Bán kính bo tròn cho hiệu ứng InkWell
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: SvgPicture.asset(iconPath, width: 28, height: 28),
      ),
    );
  }
}
