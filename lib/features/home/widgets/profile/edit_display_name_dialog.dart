import 'package:flutter/material.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';

import '../../../../core/constants/colors.dart';

class EditDisplayNameDialog extends StatefulWidget {
  final String initialValue;

  const EditDisplayNameDialog({super.key, required this.initialValue});

  @override
  State<EditDisplayNameDialog> createState() => _EditDisplayNameDialogState();
}

class _EditDisplayNameDialogState extends State<EditDisplayNameDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),

      // Tiêu đề có icon để đẹp và đồng bộ với phong cách app
      title: const Row(
        children: [
          Icon(AppIcons.displayName, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Thay đổi tên hiển thị',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
        ],
      ),

      content: Form(
        key: _formKey,
        child: AppTextField(
          controller: _controller,
          hintText: 'Nhập tên mới của bạn',
          labelText: 'Tên hiển thị',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Tên không được để trống';
            }
            return null;
          },
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _save,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
