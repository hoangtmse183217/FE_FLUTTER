import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Chỉ sử dụng danh sách các khóa tâm trạng, không còn biểu tượng
    final List<String> moodKeys = [
      'romantic',
      'lively',
      'family',
      'friends',
      'relaxing',
      'luxurious',
      'quick',
    ];

    String getLocalizedMood(String key) {
      switch (key) {
        case 'romantic':
          return localizations.romantic;
        case 'lively':
          return localizations.lively;
        case 'family':
          return localizations.family;
        case 'friends':
          return localizations.friends;
        case 'relaxing':
          return localizations.relaxing;
        case 'luxurious':
          return localizations.luxurious;
        case 'quick':
          return localizations.quick;
        default:
          return key;
      }
    }

    return SizedBox(
      height: 40, // Giảm chiều cao vì không còn icon
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: moodKeys.length,
        separatorBuilder: (context, index) => hSpaceM,
        itemBuilder: (context, index) {
          final moodKey = moodKeys[index];

          return _MoodItem(
            label: getLocalizedMood(moodKey),
            onTap: () {
              // TODO: Điều hướng đến trang khám phá với bộ lọc tâm trạng được áp dụng
              // Ví dụ: context.goNamed(AppRouteNames.discover, queryParameters: {'mood': moodKey});
              print('Selected mood: $moodKey');
            },
          );
        },
      ),
    );
  }
}

class _MoodItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MoodItem({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Bo tròn hơn cho giống chip
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingS),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
