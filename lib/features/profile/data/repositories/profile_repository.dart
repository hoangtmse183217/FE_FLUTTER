import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/profile/data/providers/profile_api_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';

class ProfileRepository {
  final _apiProvider = ProfileApiProvider();

  /// Lấy thông tin chi tiết của người dùng đang đăng nhập.
  Future<Map<String, dynamic>> getMyProfile() {
    return _apiProvider.getMyProfile();
  }

  /// Cập nhật thông tin hồ sơ.
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) {
    return _apiProvider.updateMyProfile(profileData);
  }

  /// Tải ảnh đại diện lên server.
  Future<String> uploadAvatar(XFile imageFile) {
    return _apiProvider.uploadAvatar(imageFile);
  }

  // SỬA LỖI: Thêm phương thức mới để lấy thông tin người dùng bất kỳ theo ID
  Future<User?> getUserDetails(int userId) async {
    try {
      final response = await _apiProvider.getUserDetails(userId);
      return User.fromMap(response as Map<String, dynamic>);
    } catch (e, stackTrace) {
      // Trong trường hợp không tìm thấy user hoặc có lỗi, chúng ta trả về null
      // để không làm crash ứng dụng, và log lỗi ra.
      AppLogger.error('Không thể lấy chi tiết người dùng với ID: $userId', e, stackTrace);
      return null;
    }
  }
}
