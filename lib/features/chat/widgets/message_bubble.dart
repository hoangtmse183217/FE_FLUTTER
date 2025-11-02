import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mumiappfood/features/chat/data/models/chat_message.dart';

// Widget để hiển thị một bong bóng tin nhắn
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? Theme.of(context).primaryColor : Colors.grey.shade200;
    final textColor = isUser ? Colors.white : Colors.black87;
    final borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    // SỬA LỖI: Tạo style sheet cho markdown để đảm bảo màu chữ đúng
    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontSize: 16,
      ),
      listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontSize: 16,
      ),
       h1: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
       h2: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
    );

    return Container(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
        ),
        // SỬA LỖI: Dùng MarkdownBody thay cho Text để hiển thị định dạng
        child: MarkdownBody(
          data: message.text,
          styleSheet: markdownStyleSheet,
          selectable: true, // Cho phép người dùng copy text
        ),
      ),
    );
  }
}
