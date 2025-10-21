import 'package:mumiappfood/features/profile/data/providers/profile_api_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  final _apiProvider = ProfileApiProvider();

  /// Lấy thông tin chi tiết của người dùng đang đăng nhập
  Future<Map<String, dynamic>> getMyProfile() {
    return _apiProvider.getMyProfile();
  }

  /// Cập nhật thông tin hồ sơ
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) {
    return _apiProvider.updateMyProfile(profileData);
  }

  /// Tải ảnh đại diện lên server
  Future<String> uploadAvatar(XFile imageFile) {
    return _apiProvider.uploadAvatar(imageFile);
  }
}