import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

class Favorite {
  final int id;
  final int userId;
  final int restaurantId;
  final DateTime createdAt;
  final Restaurant restaurant;

  Favorite({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.createdAt,
    required this.restaurant,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      restaurantId: map['restaurantId'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      // Lấy đối tượng restaurant từ trong map
      restaurant: Restaurant.fromMap(map['restaurant'] ?? {}),
    );
  }
}
