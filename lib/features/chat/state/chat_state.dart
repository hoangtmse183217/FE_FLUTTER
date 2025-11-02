import 'package:flutter/material.dart';
import 'package:mumiappfood/features/chat/data/models/chat_message.dart';

@immutable
abstract class ChatState {
  // SỬA LỖI: Thêm const constructor
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatLoaded({this.messages = const []});

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
    );
  }
}
