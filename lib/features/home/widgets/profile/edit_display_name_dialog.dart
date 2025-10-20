import 'package:flutter/material.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import '../../../../l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),

      title: Row(
        children: [
          const Icon(AppIcons.displayName, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            localizations.changeDisplayName,
            style: const TextStyle(
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
          hintText: localizations.enterYourNewName,
          labelText: localizations.displayName,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return localizations.nameCannotBeEmpty;
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
          child: Text(localizations.cancel),
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
          child: Text(localizations.save),
        ),
      ],
    );
  }
}
