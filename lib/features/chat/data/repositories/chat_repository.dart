import 'package:mumiappfood/features/chat/data/providers/chat_api_provider.dart';

class ChatRepository {
  final ChatApiProvider _apiProvider = ChatApiProvider();

  Future<Map<String, dynamic>> sendMessage(String message) {
    return _apiProvider.sendMessage(message);
  }

  // THÊM LẠI PHƯƠNG THỨC BỊ THIẾU
  Future<Map<String, dynamic>> suggestByMood(String mood, String location) {
    return _apiProvider.suggestByMood(mood, location);
  }
}
