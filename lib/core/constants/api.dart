class ApiConstants {
  static const String _gatewayUrl = "https://mumii-gateway.onrender.com/api";

  static String get baseUrl => _gatewayUrl;
  static String get discoveryUrl => _gatewayUrl;
  static String get socialUrl => _gatewayUrl;
  static String get aiUrl => _gatewayUrl;

  // --- Endpoints ---

  /// Authentication
  static const String register = "/auth/register";
  static const String registerPartner = "/auth/register-partner";
  static const String login = "/auth/login";
  static const String googleLogin = "/auth/google";
  static const String logout = "/auth/logout";
  static const String changePassword = "/auth/change-password";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String refresh = "/auth/refresh";

  /// Profile
  static const String myProfile = "/profile/me";
  static String userProfile(int userId) => "/profile/$userId";
  static const String uploadAvatar = "/profile/avatar";

  /// Restaurants (Partner)
  static const String partnerRestaurants = "/partner/restaurants";
  static String partnerRestaurantById(String id) => "/partner/restaurants/$id";
  static String restaurantImages(String restaurantId) => "/partner/restaurants/$restaurantId/images";
  static String restaurantImageById(String restaurantId, String imageId) => "/partner/restaurants/$restaurantId/images/$imageId";

  /// Posts (Partner)
  static const String partnerPosts = "/partner/posts";
  static String partnerPostById(String postId) => "/partner/posts/$postId";
  static String partnerPostImage(String postId) => "/partner/posts/$postId/image";
  static String partnerPostMood(String postId, int moodId) => "/partner/posts/$postId/moods/$moodId";

  /// Moods
  static const String moods = "/moods";

  /// Reviews (Partner)
  static String partnerRestaurantReviews(String restaurantId) => "/partner/restaurants/$restaurantId/reviews";
  static String partnerReplyToReview(int reviewId) => "/partner/reviews/$reviewId/reply";

  /// Notifications (Shared)
  static const String notifications = "/notifications";
  static String notificationById(int id) => "/notifications/$id/read";
  static const String readAllNotifications = "/notifications/read-all";

  /// Restaurants (User)
  static const String restaurants = "/restaurants";
  static String restaurantById(int id) => "/restaurants/$id";
  static const String searchRestaurants = "/restaurants/search";
  static const String nearbyRestaurants = "/restaurants/nearby";

  /// Reviews (User)
  static String reviewsByRestaurant(int restaurantId) => "/reviews/by-restaurant/$restaurantId";
  static String addReview(int restaurantId) => "/reviews/for-restaurant/$restaurantId";
  static String deleteReview(int id) => "/reviews/$id";
  static String updateReview(int id) => "/reviews/$id";

  /// Favorites (User)
  static const String myFavorites = "/favorites/my-favorites";
  static String toggleFavorite(int restaurantId) => "/favorites/$restaurantId";

  /// Posts & Comments (User)
  static const String posts = "/posts";
  static String postById(int id) => "/posts/$id";
  static String postsByRestaurant(int restaurantId) => "/posts/by-restaurant/$restaurantId";
  static String postComments(int postId) => "/posts/$postId/comments";

  /// AI Chat (New)
  static const String aiChatFood = "/Chat/food";
}
