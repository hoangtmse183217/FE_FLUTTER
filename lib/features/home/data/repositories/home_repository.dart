import 'package:mumiappfood/features/post/data/providers/post_api_provider.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/data/providers/restaurant_api_provider.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';

class HomeRepository {
  final RestaurantApiProvider _restaurantApiProvider;
  final PostApiProvider _postApiProvider;

  HomeRepository({
    RestaurantApiProvider? restaurantApiProvider,
    PostApiProvider? postApiProvider,
  })  : _restaurantApiProvider = restaurantApiProvider ?? RestaurantApiProvider(),
        _postApiProvider = postApiProvider ?? PostApiProvider();

  Future<Map<String, dynamic>> getHomeData() async {
    // Giả lập lấy dữ liệu moods
    await Future.delayed(const Duration(milliseconds: 200));
    final moods = [
      {'name': 'Gần bạn', 'icon': 'near_me'},
      {'name': 'Cà phê', 'icon': 'coffee'},
      {'name': 'Bữa trưa', 'icon': 'lunch_dining'},
      {'name': 'Ăn vặt', 'icon': 'fastfood'},
      {'name': 'Ăn tối', 'icon': 'dinner_dining'},
    ];

    // SỬA LỖI TRIỆT ĐỂ: Dựa vào provider, hàm getPosts đã trả về phần data
    final postResponse = await _postApiProvider.getPosts(page: 1, pageSize: 5);
    final posts = (postResponse['items'] as List? ?? [])
        .where((p) => p != null)
        .map((p) => Post.fromMap(p as Map<String, dynamic>))
        .toList();

    // SỬA LỖI TRIỆT ĐỂ: Dựa vào provider, hàm getRestaurants đã trả về phần data
    final restaurantResponse = await _restaurantApiProvider.getRestaurants(page: 1, pageSize: 10);
    final restaurants = (restaurantResponse['items'] as List? ?? [])
        .where((r) => r != null)
        .map((r) => Restaurant.fromMap(r as Map<String, dynamic>))
        .toList();

    return {
      'moods': moods,
      'posts': posts,
      'restaurants': restaurants,
    };
  }

  Future<List<Restaurant>> getNearbyRestaurants(double lat, double lng) async {
    // Provider này trả về toàn bộ response, cần truy cập vào 'data'
    final response = await _restaurantApiProvider.getNearbyRestaurants(lat: lat, lng: lng);
    final data = response['data'] as List?;
    final restaurants = (data ?? [])
        .where((r) => r != null)
        .map((r) => Restaurant.fromMap(r as Map<String, dynamic>))
        .toList();
    return restaurants;
  }
}
