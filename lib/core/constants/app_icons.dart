// lib/core/constants/app_icons.dart
import 'package:flutter/material.dart';

/// Lớp quản lý các icon được sử dụng trong ứng dụng.
/// Giúp dễ dàng thay đổi và đảm bảo tính nhất quán.
class AppIcons {
  // Icons chung
  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData close = Icons.close;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings;
  static const IconData add = Icons.add;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;

  // Icons liên quan đến món ăn
  static const IconData time = Icons.timer_outlined;
  static const IconData category = Icons.category_outlined;
  static const IconData difficulty = Icons.whatshot_outlined; // Biểu thị độ khó/độ cay
  static const IconData serving = Icons.people_outline; // Khẩu phần ăn

  // Icons cho thanh điều hướng (Navigation Bar)
  static const IconData home = Icons.home_filled;
  static const IconData discover = Icons.explore_outlined;
  static const IconData profile = Icons.person_outline;
}