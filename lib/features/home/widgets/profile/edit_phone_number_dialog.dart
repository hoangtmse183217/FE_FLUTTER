import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/app_textfield.dart';

class EditPhoneNumberDialog extends StatefulWidget {
  final String initialValue;

  const EditPhoneNumberDialog({super.key, required this.initialValue});

  @override
  State<EditPhoneNumberDialog> createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
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
      title: const Row(
        children: [
          Icon(AppIcons.phone, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Thay đổi số điện thoại',
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
          labelText: 'Số điện thoại',
          hintText: 'Nhập số điện thoại mới',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Số điện thoại không được để trống';
            }
            if (value.length < 10) {
              return 'Số điện thoại không hợp lệ';
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
