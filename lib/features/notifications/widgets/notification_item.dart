import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

import '../../../core/constants/colors.dart';

// Widget hiển thị một item thông báo, đã được cải tiến giao diện
class NotificationItem extends StatelessWidget {
  final int notificationId;
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notificationId,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isRead ? Colors.transparent : AppColors.primary.withOpacity(0.05);
    final Color titleColor = isRead ? Colors.grey.shade600 : Theme.of(context).textTheme.bodyLarge!.color!;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon thông báo
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              hSpaceM,
              // Nội dung thông báo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        color: titleColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    vSpaceXS,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    vSpaceXS,
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              // Dấu chấm chỉ báo chưa đọc
              if (!isRead)
                Padding(
                  padding: const EdgeInsets.only(left: kSpacingS, top: 4),
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
