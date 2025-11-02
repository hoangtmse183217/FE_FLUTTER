import 'dart:convert';

import 'package:mumiappfood/features/review/data/models/review_model.dart';

class ImageModel {
  final String id;
  final String imageUrl;

  ImageModel({required this.id, required this.imageUrl});

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: (map['id'] ?? '').toString(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String address;
  final String description;
  final double avgPrice;
  final double rating;
  final String status;
  final List<ImageModel> images;
  final List<Review> reviews;
  final int favoriteCount;
  final List<String> moods;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.avgPrice,
    required this.rating,
    required this.status,
    required this.images,
    required this.reviews,
    required this.favoriteCount,
    required this.moods,
    required this.latitude,
    required this.longitude,
  });

  Restaurant copyWith({
    int? id,
    String? name,
    String? address,
    String? description,
    double? avgPrice,
    double? rating,
    String? status,
    List<ImageModel>? images,
    List<Review>? reviews,
    int? favoriteCount,
    List<String>? moods,
    double? latitude,
    double? longitude,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      avgPrice: avgPrice ?? this.avgPrice,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      images: images ?? this.images,
      reviews: reviews ?? this.reviews,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      moods: moods ?? this.moods,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    List<T> parseList<T>(dynamic data, T Function(Map<String, dynamic>) fromMap) {
      if (data is List) {
        return data.where((item) => item is Map<String, dynamic>).map((item) => fromMap(item)).toList();
      }
      return [];
    }

    // SỬA LỖI TRIỆT ĐỂ: Hàm helper để parse moods một cách an toàn
    List<String> parseMoods(dynamic moodsData) {
      if (moodsData is! List) return [];
      final List<String> result = [];
      for (final item in moodsData) {
        if (item is String) {
          result.add(item);
        } else if (item is Map && item.containsKey('name')) {
          result.add(item['name'].toString());
        }
      }
      return result;
    }

    dynamic reviewsData = map['reviews'];
    List<Review> parsedReviews = [];
    if (reviewsData is List) {
      parsedReviews = parseList(reviewsData, Review.fromMap);
    } else if (reviewsData is Map && reviewsData.containsKey('items')) {
      parsedReviews = parseList(reviewsData['items'], Review.fromMap);
    }

    return Restaurant(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] ?? 'Unknown Restaurant',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      avgPrice: (map['avgPrice'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'unknown',
      images: parseList(map['images'], ImageModel.fromMap),
      reviews: parsedReviews,
      favoriteCount: (map['favoriteCount'] as num?)?.toInt() ?? 0,
      // SỬA LỖI: Sử dụng hàm parseMoods an toàn
      moods: parseMoods(map['moods']),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) => Restaurant.fromMap(json.decode(source));
}
