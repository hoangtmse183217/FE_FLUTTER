import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/data/providers/restaurant_api_provider.dart';

class RestaurantRepository {
  final RestaurantApiProvider _apiProvider;

  RestaurantRepository({RestaurantApiProvider? apiProvider})
      : _apiProvider = apiProvider ?? RestaurantApiProvider();

  Future<Map<String, dynamic>> getRestaurants({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, dynamic> responseData = await _apiProvider.getRestaurants(page: page, pageSize: pageSize);
      final List<dynamic> rawItems = responseData['items'] as List<dynamic>;
      final List<Restaurant> parsedRestaurants = rawItems.map((data) => Restaurant.fromMap(data)).toList();
      return {
        ...responseData,
        'items': parsedRestaurants,
      };
    } on RestaurantApiException catch (e) {
      throw Exception('Failed to load restaurants: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred in Repository: $e');
    }
  }

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
      final Map<String, dynamic> responseData = await _apiProvider.searchRestaurants(
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
      final List<Restaurant> parsedRestaurants = rawItems.map((data) => Restaurant.fromMap(data)).toList();
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

  Future<Restaurant> getRestaurantDetails(int restaurantId) async {
    try {
      final response = await _apiProvider.getRestaurantDetails(restaurantId);
      return Restaurant.fromMap(response['data']);
    } on RestaurantApiException catch (e) {
      throw Exception('Failed to load restaurant details: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  // SỬA LỖI: Xử lý đúng response trả về từ ApiProvider
  Future<List<Restaurant>> getNearbyRestaurants({
    required double lat,
    required double lng,
    double radiusKm = 5,
    int limit = 50,
  }) async {
    try {
      // 1. Provider trả về một Map, không phải List
      final Map<String, dynamic> responseData = await _apiProvider.getNearbyRestaurants(
        lat: lat, lng: lng, radiusKm: radiusKm, limit: limit,
      );
      // 2. Dữ liệu nhà hàng nằm trong key 'data' và là một List
      final List<dynamic> rawList = responseData['data'] as List<dynamic>;

      // 3. Parse danh sách thô thành List<Restaurant>
      return rawList.map((data) => Restaurant.fromMap(data)).toList();
    } on RestaurantApiException catch (e) {
      throw Exception('Failed to load nearby restaurants: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
