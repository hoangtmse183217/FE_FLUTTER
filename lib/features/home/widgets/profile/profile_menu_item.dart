import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool isEditable;
  final Color? textColor; // Tham số mới được thêm vào

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
    this.isEditable = true,
    this.textColor, // Thêm vào constructor
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingM),
        child: Row(
          children: [
            // Icon cũng sẽ nhận màu mới để đồng bộ
            Icon(icon, color: textColor ?? AppColors.textSecondary),
            hSpaceM,
            Expanded(
              child: Text(
                title,
                // Sử dụng tham số textColor nếu được cung cấp
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            if (isEditable) ...[
              hSpaceS,
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
