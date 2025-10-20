import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class MoodFilterChip extends StatelessWidget {
  final String mood; // This is now a key, e.g., 'family', 'relaxing'
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const MoodFilterChip({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onSelected,
  });

  // Helper function to get the localized string from a mood key
  String _getLocalizedMood(BuildContext context, String moodKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (moodKey) {
      case 'family':
        return localizations.family;
      case 'relaxing':
        return localizations.relaxing;
      case 'romantic':
        return localizations.romantic;
      // Add other moods from your app here if needed
      default:
        return moodKey; // Fallback to the key if no translation is found
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizedMoodString = _getLocalizedMood(context, mood);

    return FilterChip(
      label: Text(localizedMoodString),
      selected: isSelected,
      onSelected: (bool selected) {
        // Always pass the original key back, not the translated string
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
