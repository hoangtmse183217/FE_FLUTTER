import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';


import '../../../l10n/app_localizations.dart';
import '../widgets/notification/notification_item.dart';

// Dữ liệu giả, bạn sẽ thay thế bằng dữ liệu từ Firestore/API
final List<Map<String, dynamic>> _todayNotifications = [
  {
    'icon': Icons.new_releases,
    'color': Colors.blue,
    'title': 'Nhà hàng mới: Lẩu Phan vừa tham gia!',
    'subtitle': 'Khám phá ngay thực đơn lẩu hấp dẫn gần bạn.',
    'time': '15 phút trước',
  },
  {
    'icon': Icons.local_offer,
    'color': Colors.orange,
    'title': 'Ưu đãi đặc biệt từ Pizza 4P\'s',
    'subtitle': 'Giảm 20% cho tất cả các loại pizza hải sản.',
    'time': '2 giờ trước',
  },
];

final List<Map<String, dynamic>> _thisWeekNotifications = [
  {
    'icon': Icons.rate_review,
    'color': Colors.green,
    'title': 'The Deck Saigon đã trả lời đánh giá của bạn.',
    'subtitle': '"Cảm ơn bạn đã ghé thăm! Rất vui vì bạn đã có trải nghiệm tốt."',
    'time': 'Hôm qua',
  },
];

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notifications),
      ),
      body: ListView(
        padding: const EdgeInsets.all(kSpacingM),
        children: [
          // Phần thông báo "Hôm nay"
          _buildSectionTitle(context, localizations.today),
          vSpaceM,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todayNotifications.length,
            separatorBuilder: (context, index) => vSpaceS,
            itemBuilder: (context, index) {
              final item = _todayNotifications[index];
              return NotificationItem(
                icon: item['icon'],
                iconColor: item['color'],
                title: item['title'],
                subtitle: item['subtitle'],
                time: item['time'],
              );
            },
          ),
          vSpaceL,

          // Phần thông báo "Tuần này"
          _buildSectionTitle(context, localizations.thisWeek),
          vSpaceM,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _thisWeekNotifications.length,
            separatorBuilder: (context, index) => vSpaceS,
            itemBuilder: (context, index) {
              final item = _thisWeekNotifications[index];
              return NotificationItem(
                icon: item['icon'],
                iconColor: item['color'],
                title: item['title'],
                subtitle: item['subtitle'],
                time: item['time'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
