import 'package:mumiappfood/features/profile/data/providers/profile_api_provider.dart';

class ProfileRepository {
  final _apiProvider = ProfileApiProvider();

  Future<Map<String, dynamic>> getMyProfile() {
    return _apiProvider.getMyProfile();
  }

  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) {
    return _apiProvider.updateMyProfile(profileData);
  }
}