class User {
  final int id;
  final String email;
  final String fullname;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    required this.fullname,
    this.avatar,
  });

  User copyWith({
    int? id,
    String? email,
    String? fullname,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      avatar: avatar ?? this.avatar,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // SỬA LỖI: Thêm logic kiểm tra kiểu dữ liệu an toàn
    Map<String, dynamic>? profile;
    if (map['profile'] is Map<String, dynamic>) {
      profile = map['profile'] as Map<String, dynamic>;
    }

    return User(
      // SỬA LỖI: Ép kiểu an toàn hơn cho ID
      id: (map['id'] is num) ? (map['id'] as num).toInt() : 0,
      email: map['email'] as String? ?? '',
      fullname: map['fullname'] as String? ?? 'Người dùng ẩn danh',
      // Logic này vẫn đúng, nhưng giờ nó an toàn hơn do `profile` đã được kiểm tra
      avatar: profile?['avatar'] as String? ?? map['avatar'] as String?,
    );
  }
}
