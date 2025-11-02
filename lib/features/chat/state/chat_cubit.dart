import 'package:bloc/bloc.dart';
import 'package:mumiappfood/features/chat/data/models/chat_message.dart';
import 'package:mumiappfood/features/chat/data/repositories/chat_repository.dart';
import 'package:mumiappfood/features/chat/state/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  ChatCubit() : _chatRepository = ChatRepository(), super(const ChatInitial());

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(text: text, sender: MessageSender.user);
    _addMessageToState(userMessage);

    final thinkingMessage = ChatMessage(text: '...', sender: MessageSender.bot);
    _addMessageToState(thinkingMessage);

    try {
      final response = await _chatRepository.sendMessage(text);
      final String answer = response['answer'] as String? ?? 'Xin lỗi, tôi không có câu trả lời.';
      final List<String> relatedTopics = (response['relatedTopics'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

      final botMessage = ChatMessage(
        text: answer,
        sender: MessageSender.bot,
        relatedTopics: relatedTopics,
      );
      _replaceLastMessage(botMessage);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> getMoodSuggestions(String mood, String location) async {
    final userRequest = 'Tâm trạng: **$mood**\nĐịa điểm: **$location**';
    final userMessage = ChatMessage(text: userRequest, sender: MessageSender.user);
    emit(ChatLoaded(messages: [userMessage]));

    final thinkingMessage = ChatMessage(text: 'Đang tìm gợi ý phù hợp cho bạn...', sender: MessageSender.bot);
    _addMessageToState(thinkingMessage);

    try {
      final response = await _chatRepository.suggestByMood(mood, location);
      final suggestions = (response['suggestions'] as List<dynamic>?) ?? [];

      if (suggestions.isNotEmpty) {
        String formattedSuggestions = suggestions.map((s) {
          return '**${s['foodName']}**\n*Lý do:* ${s['reason']}\n*Giá:* ${s['priceRange']}\n';
        }).join('\n---\n');

        final botMessage = ChatMessage(text: formattedSuggestions, sender: MessageSender.bot);
        _replaceLastMessage(botMessage);
      } else {
        _replaceLastMessage(ChatMessage(text: 'Rất tiếc, tôi không tìm thấy gợi ý nào phù hợp.', sender: MessageSender.bot));
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _addMessageToState(ChatMessage message) {
    final currentState = state;
    // SỬA LỖI: Khởi tạo với đúng kiểu <ChatMessage>[]
    final currentMessages = currentState is ChatLoaded ? List<ChatMessage>.from(currentState.messages) : <ChatMessage>[];
    currentMessages.insert(0, message);
    emit(ChatLoaded(messages: currentMessages));
  }

  void _replaceLastMessage(ChatMessage message) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      // SỬA LỖI: Khởi tạo với đúng kiểu List<ChatMessage>.from
      final currentMessages = List<ChatMessage>.from(currentState.messages);
      currentMessages.removeAt(0);
      currentMessages.insert(0, message);
      emit(ChatLoaded(messages: currentMessages));
    }
  }

  void _handleError(Object e) {
    final errorMessage = ChatMessage(text: 'Đã có lỗi xảy ra: ${e.toString()}', sender: MessageSender.bot);
    _replaceLastMessage(errorMessage);
  }
}
