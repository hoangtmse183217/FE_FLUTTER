// lib/features/notifications/widgets/notification_item.dart

import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        onTap: () {
          // TODO: Điều hướng đến trang chi tiết liên quan (nhà hàng, ưu đãi...)
        },
      ),
    );
  }
}