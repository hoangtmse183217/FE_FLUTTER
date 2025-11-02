import 'package:mumiappfood/features/user/data/models/user_model.dart';

class Review {
  final int id;
  final int? userId;
  final int restaurantId; // THÊM MỚI
  final double rating;
  final String comment;
  final DateTime createdAt;
  final User? user;
  final String? partnerReplyComment;

  Review({
    required this.id,
    this.userId,
    required this.restaurantId, // THÊM MỚI
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.user,
    this.partnerReplyComment,
  });

  Review copyWith({
    int? id,
    int? userId,
    int? restaurantId, // THÊM MỚI
    double? rating,
    String? comment,
    DateTime? createdAt,
    User? user,
    String? partnerReplyComment,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId, // THÊM MỚI
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      partnerReplyComment: partnerReplyComment ?? this.partnerReplyComment,
    );
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int? ?? 0,
      userId: map['userId'] as int?,
      restaurantId: map['restaurantId'] as int? ?? 0, // THÊM MỚI
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: (map['comment'] ?? '').toString(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String, dynamic>) : null,
      partnerReplyComment: map['partnerReplyComment']?.toString(),
    );
  }
}
