import 'package:mumiappfood/features/favorites/data/models/favorite_model.dart';
import 'package:mumiappfood/features/favorites/data/providers/favorites_api_provider.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

class FavoritesRepository {
  final FavoritesApiProvider _apiProvider;

  FavoritesRepository({FavoritesApiProvider? apiProvider})
      : _apiProvider = apiProvider ?? FavoritesApiProvider();

  // SỬA ĐỔI: Phương thức này giờ sẽ trả về List<Favorite> thay vì List<Restaurant>
  Future<List<Favorite>> getMyFavorites() async {
    final Map<String, dynamic> responseData = await _apiProvider.getMyFavorites();
    final List<dynamic> rawData = responseData['data'] ?? [];
    // Sử dụng model Favorite mới để parse dữ liệu một cách an toàn
    return rawData.map((data) => Favorite.fromMap(data)).toList();
  }

  Future<void> addFavorite(int restaurantId) async {
    await _apiProvider.addFavorite(restaurantId);
  }

  Future<void> removeFavorite(int restaurantId) async {
    await _apiProvider.removeFavorite(restaurantId);
  }
}
