import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

// Một widget để nhóm các cài đặt lại với nhau, có thể có tiêu đề và viền Card.
class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> tiles;
  final bool showCard;

  const SettingsSection({super.key, this.title, required this.tiles, this.showCard = true});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(kSpacingS, 0, 0, kSpacingS),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
          ),
        if (showCard)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200, width: 1)),
            clipBehavior: Clip.antiAlias,
            child: Column(children: tiles),
          )
        else
          Column(children: tiles),
      ],
    );

    return content;
  }
}
