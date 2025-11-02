import 'package:flutter/foundation.dart';

@immutable
class Mood {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Mood({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
