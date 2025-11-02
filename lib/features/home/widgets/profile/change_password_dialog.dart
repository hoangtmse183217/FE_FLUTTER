import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/auth/data/repositories/auth_repository.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});
  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _authRepository = AuthRepository();
  var _status = ChangePasswordStatus.initial;
  String _errorMessage = '';

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _status = ChangePasswordStatus.loading; });
      try {
        await _authRepository.changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
        setState(() { _status = ChangePasswordStatus.success; });
        if (mounted) {
          AppSnackbar.showSuccess(context, 'Đổi mật khẩu thành công!');
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _status = ChangePasswordStatus.failure;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đổi mật khẩu'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _currentPasswordController, labelText: 'Mật khẩu hiện tại', hintText: 'Nhập mật khẩu hiện tại', isPassword: true, validator: ValidatorUtils.notEmpty),
            vSpaceM,
            AppTextField(controller: _newPasswordController, labelText: 'Mật khẩu mới', hintText: 'Nhập mật khẩu mới', isPassword: true, validator: ValidatorUtils.password),
            if (_status == ChangePasswordStatus.failure) ...[
              vSpaceS,
              Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
        AppButton(text: 'Lưu', isLoading: _status == ChangePasswordStatus.loading, onPressed: _submit),
      ],
    );
  }
}
