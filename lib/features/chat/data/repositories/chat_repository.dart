import 'package:mumiappfood/features/chat/data/providers/chat_api_provider.dart';

class ChatRepository {
  final ChatApiProvider _chatApiProvider;

  ChatRepository({ChatApiProvider? chatApiProvider})
      : _chatApiProvider = chatApiProvider ?? ChatApiProvider();

  Future<Map<String, dynamic>> sendMessage(String message) {
    return _chatApiProvider.sendMessage(message);
  }
}
