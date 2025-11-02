import 'package:equatable/equatable.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

// Enum để quản lý trạng thái của các mục một cách độc lập
enum HomeSectionStatus { initial, loading, success, failure }

enum LocationPermissionStatus { initial, granted, denied, deniedForever, serviceDisabled }

class HomeState extends Equatable {
  // Trạng thái cho mục "Nhà hàng gần bạn"
  final HomeSectionStatus nearbyStatus;
  final List<Restaurant> nearbyRestaurants;
  final LocationPermissionStatus locationPermissionStatus;
  final String? nearbyErrorMessage;

  // Trạng thái cho mục "Bài viết mới"
  final HomeSectionStatus postsStatus;
  final List<Post> posts;
  final String? postsErrorMessage;

  // Trạng thái cho mục "Nhà hàng cho bạn"
  final HomeSectionStatus recommendedStatus;
  final List<Restaurant> recommendedRestaurants;
  final String? recommendedErrorMessage;

  final List<dynamic> moods;

  const HomeState({
    // Gần bạn
    this.nearbyStatus = HomeSectionStatus.initial,
    this.nearbyRestaurants = const [],
    this.locationPermissionStatus = LocationPermissionStatus.initial,
    this.nearbyErrorMessage,
    // Bài viết
    this.postsStatus = HomeSectionStatus.initial,
    this.posts = const [],
    this.postsErrorMessage,
    // Đề xuất
    this.recommendedStatus = HomeSectionStatus.initial,
    this.recommendedRestaurants = const [],
    this.recommendedErrorMessage,
    // Moods
    this.moods = const [],
  });

  HomeState copyWith({
    HomeSectionStatus? nearbyStatus,
    List<Restaurant>? nearbyRestaurants,
    LocationPermissionStatus? locationPermissionStatus,
    String? nearbyErrorMessage,
    bool clearNearbyError = false,

    HomeSectionStatus? postsStatus,
    List<Post>? posts,
    String? postsErrorMessage,
    bool clearPostsError = false,

    HomeSectionStatus? recommendedStatus,
    List<Restaurant>? recommendedRestaurants,
    String? recommendedErrorMessage,
    bool clearRecommendedError = false,

    List<dynamic>? moods,
  }) {
    return HomeState(
      nearbyStatus: nearbyStatus ?? this.nearbyStatus,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      locationPermissionStatus: locationPermissionStatus ?? this.locationPermissionStatus,
      nearbyErrorMessage: clearNearbyError ? null : nearbyErrorMessage ?? this.nearbyErrorMessage,
      
      postsStatus: postsStatus ?? this.postsStatus,
      posts: posts ?? this.posts,
      postsErrorMessage: clearPostsError ? null : postsErrorMessage ?? this.postsErrorMessage,

      recommendedStatus: recommendedStatus ?? this.recommendedStatus,
      recommendedRestaurants: recommendedRestaurants ?? this.recommendedRestaurants,
      recommendedErrorMessage: clearRecommendedError ? null : recommendedErrorMessage ?? this.recommendedErrorMessage,

      moods: moods ?? this.moods,
    );
  }

  @override
  List<Object?> get props => [
        nearbyStatus,
        nearbyRestaurants,
        locationPermissionStatus,
        nearbyErrorMessage,
        postsStatus,
        posts,
        postsErrorMessage,
        recommendedStatus,
        recommendedRestaurants,
        recommendedErrorMessage,
        moods,
      ];
}
