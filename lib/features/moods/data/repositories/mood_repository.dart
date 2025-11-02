import '../providers/mood_api_provider.dart';

class MoodRepository {
  final _apiProvider = MoodApiProvider();

  Future<List<dynamic>> getMoods() async {
    try {
      final moods = await _apiProvider.fetchAllMoods();

      // NẾU API TRẢ VỀ DANH SÁCH RỖNG, NÉM LỖI ĐỂ UI BIẾT
      if (moods.isEmpty) {
        throw Exception('Không có dữ liệu tâm trạng.');
      }

      return moods;
    } on MoodApiException catch (e) {
      // Gói lại lỗi từ provider với thông điệp rõ ràng hơn
      throw Exception('Không thể tải danh sách tâm trạng: ${e.message}');
    } catch (e) {
      // Bắt các lỗi không mong muốn khác
      throw Exception('Đã xảy ra lỗi không mong muốn khi tải tâm trạng.');
    }
  }
}
