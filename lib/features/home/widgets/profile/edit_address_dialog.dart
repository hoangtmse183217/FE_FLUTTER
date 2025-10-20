import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import '../../../../l10n/app_localizations.dart';

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
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.surface,
      title: Text(localizations.changeAddress),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: AppTextField(
            controller: _controller,
            labelText: localizations.address,
            hintText: localizations.enterYourNewAddress,
            prefixIcon: Icons.location_on_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return localizations.addressCannotBeEmpty;
              }
              return null;
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
        ),
        AppButton(
          text: localizations.save,
          onPressed: _save,
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    );
  }
}
