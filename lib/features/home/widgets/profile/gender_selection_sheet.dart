import 'package:flutter/material.dart';

class GenderSelectionSheet extends StatefulWidget {
  final String initialValue;

  const GenderSelectionSheet({super.key, required this.initialValue});

  @override
  State<GenderSelectionSheet> createState() => _GenderSelectionSheetState();
}

class _GenderSelectionSheetState extends State<GenderSelectionSheet> {
  late String _selectedValue;
  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Chọn giới tính', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Sử dụng Column để tạo danh sách các lựa chọn
          Column(
            children: _genders.map((gender) {
              return RadioListTile<String>(
                title: Text(gender),
                value: gender,
                groupValue: _selectedValue,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedValue = value;
                    });
                    // Đóng BottomSheet và trả về giá trị đã chọn ngay lập tức
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