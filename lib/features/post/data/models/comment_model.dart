import 'package:mumiappfood/features/user/data/models/user_model.dart';

class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  User? user; // SỬA: Cho phép user là nullable và không final

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.user, // SỬA: Cho phép user là nullable
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int? ?? 0,
      content: map['content'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String, dynamic>) : null,
    );
  }

  // Thêm copyWith để dễ dàng tạo bản sao cập nhật
  Comment copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }
}
