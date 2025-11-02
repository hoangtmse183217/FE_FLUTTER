import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/colors.dart';

// Widget chứa trường nhập văn bản và nút gửi
class TextInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const TextInputField({super.key, required this.onSendMessage, this.isLoading = false});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendMessage(_controller.text.trim());
      _controller.clear();
      FocusScope.of(context).unfocus(); // Ẩn bàn phím
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(offset: const Offset(0, -1), color: Colors.grey.shade200, blurRadius: 2),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: 'Nhập câu hỏi của bạn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3)),
                  )
                : IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                    onPressed: _sendMessage,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
