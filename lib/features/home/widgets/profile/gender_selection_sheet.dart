import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class GenderSelectionSheet extends StatefulWidget {
  // SỬA LỖI: Luôn nhận vào giá trị tiếng Anh chuẩn
  final String initialValue; // Expects 'Male', 'Female', or 'Other'

  const GenderSelectionSheet({super.key, required this.initialValue});

  @override
  State<GenderSelectionSheet> createState() => _GenderSelectionSheetState();
}

class _GenderSelectionSheetState extends State<GenderSelectionSheet> {
  late String _selectedValue;
  // SỬA LỖI: Dùng danh sách các key tiếng Anh cố định
  final List<String> _genderKeys = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedValue = _genderKeys.contains(widget.initialValue) ? widget.initialValue : _genderKeys.first;
  }

  // SỬA LỖI: Hàm dịch key sang ngôn ngữ hiển thị
  String _getLocalizedGender(BuildContext context, String genderKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (genderKey) {
      case 'Male':
        return localizations.male;
      case 'Female':
        return localizations.female;
      case 'Other':
        return localizations.other;
      default:
        return genderKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(localizations.selectGender, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              // SỬA LỖI: Dùng danh sách key để tạo RadioListTile
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
                      // SỬA LỖI: Luôn trả về key tiếng Anh
                      Navigator.pop(context, _selectedValue);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
