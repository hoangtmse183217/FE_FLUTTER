import 'package:mumiappfood/features/user/data/models/user_model.dart';

class Post {
  final int id;
  final int? partnerId;
  final int? restaurantId;
  final String title;
  final String content;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;
  final List<dynamic> moods;

  // SỬA LỖI: Thêm trường author để chứa thông tin tác giả bài viết
  final User? author;

  Post({
    required this.id,
    this.partnerId,
    this.restaurantId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.moods,
    this.author, // Thêm vào constructor
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      title: map['title'] ?? 'Không có tiêu đề',
      content: map['content'] ?? '',
      status: map['status'] ?? 'Unknown',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      moods: map['moods'] as List<dynamic>? ?? [],
      partnerId: map['partnerId'] as int?,
      restaurantId: map['restaurantId'] as int?,
      imageUrl: map['imageUrl'] as String?,
      // author không được parse ở đây vì nó không có trong JSON ban đầu.
      // Nó sẽ được thêm vào sau ở tầng logic.
    );
  }

  // Thêm phương thức copyWith để dễ dàng cập nhật object một cách an toàn
  Post copyWith({
    int? id,
    int? partnerId,
    int? restaurantId,
    String? title,
    String? content,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    List<dynamic>? moods,
    User? author,
  }) {
    return Post(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      restaurantId: restaurantId ?? this.restaurantId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      moods: moods ?? this.moods,
      author: author ?? this.author,
    );
  }
}
