import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class AddressInputPage extends StatefulWidget {
  const AddressInputPage({super.key});

  @override
  State<AddressInputPage> createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAddress() {
    final address = _controller.text.trim();
    if (address.isNotEmpty) {
      Navigator.pop(context, address);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.address),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.address),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: loc.address, //
                hintText: '${loc.address}...',
              ),
              onSubmitted: (_) => _submitAddress(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitAddress,
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}
