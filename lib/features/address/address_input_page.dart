import 'package:flutter/material.dart';

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
        const SnackBar(content: Text('Vui lòng nhập địa chỉ!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập địa chỉ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nhập địa chỉ của bạn'),
              onSubmitted: (_) => _submitAddress(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitAddress,
              child: const Text('Tìm'),
            ),
          ],
        ),
      ),
    );
  }
}
