import 'package:mumiappfood/features/restaurant/data/providers/restaurant_api_provider.dart';

import '../../../moods/data/providers/mood_api_provider.dart';
import '../../../restaurant/data/models/restaurant_model.dart';

/// Repository for handling discovery-related data operations.
class DiscoveryRepository {
  final RestaurantApiProvider _restaurantApiProvider;
  final MoodApiProvider _moodsApiProvider;

  DiscoveryRepository({
    RestaurantApiProvider? restaurantApiProvider,
    MoodApiProvider? moodsApiProvider,
  })  : _restaurantApiProvider = restaurantApiProvider ?? RestaurantApiProvider(),
        _moodsApiProvider = moodsApiProvider ?? MoodApiProvider();

  Future<List<String>> getAvailableMoods() async {
    try {
      final List<dynamic> rawMoods = await _moodsApiProvider.fetchAllMoods();
      return rawMoods.map((mood) => mood.toString()).toList();
    } on RestaurantApiException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching moods: $e');
    }
  }

  /// SỬA ĐỔI: Chấp nhận các bộ lọc nâng cao và trả về Map để hỗ trợ phân trang trong tương lai.
  Future<Map<String, dynamic>> searchRestaurants({
    String? q,
    double? lat,
    double? lng,
    double? radiusKm,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, dynamic> responseData =
          await _restaurantApiProvider.searchRestaurants(
        q: q,
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        page: page,
        pageSize: pageSize,
      );
      final List<dynamic> rawItems = responseData['items'] as List<dynamic>;
      final List<Restaurant> parsedRestaurants =
          rawItems.map((data) => Restaurant.fromMap(data)).toList();
      
      // Trả về một bản sao của response, nhưng thay thế 'items' thô bằng danh sách đã được parse.
      return {
        ...responseData,
        'items': parsedRestaurants,
      };
    } on RestaurantApiException catch (e) {
      throw Exception('Failed to search restaurants: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred in Repository search: $e');
    }
  }
}