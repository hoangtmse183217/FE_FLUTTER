import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class GenderSelectionSheet extends StatefulWidget {
  final String initialValue; // Expects a key: 'male', 'female', or 'other'

  const GenderSelectionSheet({super.key, required this.initialValue});

  @override
  State<GenderSelectionSheet> createState() => _GenderSelectionSheetState();
}

class _GenderSelectionSheetState extends State<GenderSelectionSheet> {
  late String _selectedValue;
  // Use a list of stable keys for genders
  final List<String> _genderKeys = ['male', 'female', 'other'];

  @override
  void initState() {
    super.initState();
    // Ensure the initial value is one of the valid keys
    _selectedValue = _genderKeys.contains(widget.initialValue) ? widget.initialValue : _genderKeys.first;
  }

  String _getLocalizedGender(BuildContext context, String genderKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (genderKey) {
      case 'male':
        return localizations.male;
      case 'female':
        return localizations.female;
      case 'other':
        return localizations.other;
      default:
        return genderKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(localizations.selectGender, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Column(
            children: _genderKeys.map((genderKey) {
              return RadioListTile<String>(
                title: Text(_getLocalizedGender(context, genderKey)),
                value: genderKey,
                groupValue: _selectedValue,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedValue = value;
                    });
                    // Pop and return the selected key
                    Navigator.pop(context, _selectedValue);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
