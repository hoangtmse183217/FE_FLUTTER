import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/chat/data/models/chat_message.dart';
import 'package:mumiappfood/features/chat/state/chat_cubit.dart';
import 'package:mumiappfood/features/chat/state/chat_state.dart';
import 'package:mumiappfood/features/chat/widgets/message_bubble.dart'; // Sửa import

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _sendTopic(String topic) {
    context.read<ChatCubit>().sendMessage(topic);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Gợi ý món ăn'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(kSpacingM),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      // SỬA LỖI: Cập nhật lại widget bubble
                      return _buildMessageBubble(message);
                    },
                  );
                }
                return const Center(
                  child: Text('Hãy bắt đầu cuộc trò chuyện!'),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // SỬA LỖI: Tách widget bubble ra
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.sender == MessageSender.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          MessageBubble(message: message),
          if (message.relatedTopics != null && message.relatedTopics!.isNotEmpty) ...[
            vSpaceS,
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: kSpacingS,
                runSpacing: kSpacingS,
                children: message.relatedTopics!.map((topic) {
                  return ActionChip(
                    label: Text(topic),
                    onPressed: () => _sendTopic(topic),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey[300]!)
                    ),
                  );
                }).toList(),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(kSpacingS),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: kSpacingL),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            hSpaceS,
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
