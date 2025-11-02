import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/chat/state/chat_cubit.dart';
import 'package:mumiappfood/features/chat/state/chat_state.dart';
import 'package:mumiappfood/features/chat/widgets/message_list.dart';
import 'package:mumiappfood/features/chat/widgets/suggestion_bottom_sheet.dart';

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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(text);
      _controller.clear();
    }
  }

  void _showSuggestionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        // Cung cấp ChatCubit hiện tại cho BottomSheet
        return BlocProvider.value(
          value: context.read<ChatCubit>(),
          child: const SuggestionBottomSheet(),
        );
      },
    );
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
                  return MessageList(messages: state.messages);
                }
                // Giao diện ban đầu: Lời chào
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(kSpacingL),
                    child: Text(
                      'Bạn cần tìm món gì? Hãy chat với tôi hoặc thử gợi ý nâng cao nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(), // Vùng nhập liệu luôn hiển thị
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
            // Nút mở gợi ý nâng cao
            IconButton(
              icon: const Icon(Icons.auto_awesome_outlined), // Icon tia lửa
              onPressed: _showSuggestionSheet,
              tooltip: 'Gợi ý nâng cao',
            ),
            // Ô nhập liệu
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: kSpacingL, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            hSpaceS,
            // Nút gửi
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
