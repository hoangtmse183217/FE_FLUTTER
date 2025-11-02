import 'package:bloc/bloc.dart';
import 'package:mumiappfood/features/chat/data/models/chat_message.dart';
import 'package:mumiappfood/features/chat/data/repositories/chat_repository.dart';
import 'package:mumiappfood/features/chat/state/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  ChatCubit() : _chatRepository = ChatRepository(), super(const ChatInitial());

  Future<void> sendMessage(String text) async {
    // SỬA LỖI: Sử dụng MessageSender.user
    final userMessage = ChatMessage(text: text, sender: MessageSender.user);
    final currentState = state;
    List<ChatMessage> currentMessages = currentState is ChatLoaded ? List.from(currentState.messages) : [];

    currentMessages.insert(0, userMessage);
    emit(ChatLoaded(messages: currentMessages));

    final thinkingMessage = ChatMessage(text: '...', sender: MessageSender.bot);
    currentMessages.insert(0, thinkingMessage);
    emit(ChatLoaded(messages: List.from(currentMessages)));

    try {
      final response = await _chatRepository.sendMessage(text);
      final String answer = response['answer'] as String? ?? 'Xin lỗi, tôi không có câu trả lời.';
      final List<String> relatedTopics = (response['relatedTopics'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

      final botMessage = ChatMessage(
        text: answer,
        sender: MessageSender.bot,
        relatedTopics: relatedTopics,
      );

      currentMessages.removeAt(0); 
      currentMessages.insert(0, botMessage);
      emit(ChatLoaded(messages: currentMessages));

    } catch (e) {
      final errorMessage = ChatMessage(text: 'Đã có lỗi xảy ra: ${e.toString()}', sender: MessageSender.bot);
      currentMessages.removeAt(0); 
      currentMessages.insert(0, errorMessage);
      emit(ChatLoaded(messages: currentMessages));
    }
  }
}
