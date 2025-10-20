import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';

class EditAddressDialog extends StatefulWidget {
  final String initialValue;

  const EditAddressDialog({super.key, required this.initialValue});

  @override
  State<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
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
      // Sử dụng context.pop của GoRouter cho an toàn và nhất quán
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 1. TÙY CHỈNH GIAO DIỆN CỦA DIALOG
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.surface,
      title: const Text('Thay đổi địa chỉ'),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      // Sử dụng SizedBox để dialog không bị quá rộng trên màn hình lớn
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: AppTextField(
            controller: _controller,
            labelText: 'Địa chỉ',
            hintText: 'Nhập địa chỉ mới của bạn',
            prefixIcon: Icons.location_on_outlined, // 2. Thêm icon
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Địa chỉ không được để trống';
              }
              return null;
            },
          ),
        ),
      ),
      // 3. TÙY CHỈNH CÁC NÚT HÀNH ĐỘNG
      actions: <Widget>[
        // Nút Hủy (dùng TextButton)
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),

        ),
        // Nút Lưu (dùng AppButton đã tạo)
        AppButton(
          text: 'Lưu',
          onPressed: _save,
        ),
      ],
      // 4. TÙY CHỈNH PADDING
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    );
  }
}