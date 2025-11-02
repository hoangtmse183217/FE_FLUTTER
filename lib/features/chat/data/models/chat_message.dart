// SỬA LỖI: Đồng bộ enum theo message_bubble.dart
enum MessageSender { user, bot }

class ChatMessage {
  final String text;
  // SỬA LỖI: Đồng bộ tên thuộc tính
  final MessageSender sender;
  final List<String>? relatedTopics;

  ChatMessage({
    required this.text,
    required this.sender,
    this.relatedTopics,
  });
}
