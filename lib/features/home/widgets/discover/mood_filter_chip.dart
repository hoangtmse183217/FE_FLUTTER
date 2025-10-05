import 'package:flutter/material.dart';

class MoodFilterChip extends StatelessWidget {
  final String mood;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const MoodFilterChip({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(mood),
      selected: isSelected,
      onSelected: (bool selected) {
        onSelected(mood);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      side: isSelected
          ? BorderSide(color: Theme.of(context).primaryColor)
          : BorderSide(color: Colors.grey[300]!),
    );
  }
}