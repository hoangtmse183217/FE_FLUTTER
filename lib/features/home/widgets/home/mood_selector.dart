import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

// Dữ liệu giả cho các Mood
final List<Map<String, dynamic>> moods = [
  {'name': 'Lãng mạn', 'icon': Icons.favorite_border},
  {'name': 'Sôi động', 'icon': Icons.celebration_outlined},
  {'name': 'Thư giãn', 'icon': Icons.self_improvement_outlined},
  {'name': 'Sang trọng', 'icon': Icons.diamond_outlined},
  {'name': 'Gia đình', 'icon': Icons.family_restroom},
  {'name': 'Nhanh gọn', 'icon': Icons.flash_on},
  {'name': 'Bạn bè', 'icon': Icons.group},
];

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          return Padding(
            padding: const EdgeInsets.only(right: kSpacingM),
            child: InkWell(
              onTap: () {
                // TODO: Gọi Cubit để lọc nhà hàng theo mood['name']
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(mood['icon'], color: Theme.of(context).primaryColor),
                  ),
                  vSpaceS,
                  Text(mood['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}