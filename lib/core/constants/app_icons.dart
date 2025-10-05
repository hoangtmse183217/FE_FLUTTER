import 'package:flutter/material.dart';

/// Lớp quản lý các icon được sử dụng trong ứng dụng.
/// Giúp dễ dàng thay đổi và đảm bảo tính nhất quán.
class AppIcons {
  // 🔹 Icons chung
  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData close = Icons.close;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData check = Icons.check_circle_outline;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;

  // 🔹 Icons liên quan đến món ăn
  static const IconData time = Icons.timer_outlined;
  static const IconData category = Icons.category_outlined;
  static const IconData difficulty = Icons.whatshot_outlined; // Biểu thị độ khó/độ cay
  static const IconData serving = Icons.people_outline; // Khẩu phần ăn

  // 🔹 Icons cho thanh điều hướng (Navigation Bar)
  static const IconData home = Icons.home_filled;
  static const IconData discover = Icons.explore_outlined;
  static const IconData profile = Icons.person_outline;

  // 🔹 Icons liên quan đến tài khoản & thông tin người dùng
  static const IconData user = Icons.person_outline;
  static const IconData displayName = Icons.badge_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData logout = Icons.logout;

  // 🔹 Icons liên quan đến giao dịch, giỏ hàng, v.v.
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData order = Icons.receipt_long_outlined;
  static const IconData payment = Icons.payment_outlined;

  // 🔹 Icons khác
  static const IconData location = Icons.location_on_outlined;
  static const IconData notification = Icons.notifications_none;
  static const IconData info = Icons.info_outline;
}
