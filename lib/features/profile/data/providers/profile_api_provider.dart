import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mumiappfood/core/constants/api.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileException implements Exception {
  final String message;
  ProfileException(this.message);
  @override
  String toString() => message;
}

class ProfileApiProvider {

  Future<Map<String, dynamic>> getMyProfile() async {
    final accessToken = await AuthService.getValidAccessToken();

    if (accessToken == null) {
      throw ProfileException('Token is null. User not logged in or session expired.');
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.myProfile}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      if (kDebugMode) {
        print('--- DEBUG PROFILE_API_PROVIDER ---');
        print('URL GỌI: $uri');
        print('HEADERS GỬI ĐI: $headers');
      }

      final response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('STATUS CODE: ${response.statusCode}');
        print('RAW BODY: ${response.body}');
        print('--- END DEBUG ---');
      }
      
      if (response.body.isEmpty) {
        throw ProfileException('Response body is empty (Status Code: ${response.statusCode}).');
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? responseData['profile'] ?? responseData;
        if (data is Map<String, dynamic>) {
          return data;
        } else {
           throw ProfileException('Data format is not a valid Map.');
        }
      } else {
        final msg = responseData['message'] ?? responseData['error'] ?? 'Failed to load profile.';
        throw ProfileException(msg);
      }
    } on SocketException {
      throw ProfileException('No Internet connection.');
    } on TimeoutException {
      throw ProfileException('Connection to server timed out.');
    } on FormatException {
       throw ProfileException('Failed to parse server response. Check RAW BODY log.');
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ProfileException('Token is null.');

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.myProfile}');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
    
    try {
      final response = await http.put(uri, headers: headers, body: jsonEncode(profileData));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData['data'] ?? responseData;
      } else {
        throw ProfileException(responseData['message'] ?? 'Update failed.');
      }
    } catch (e) { rethrow; }
  }

  Future<String> uploadAvatar(XFile imageFile) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ProfileException('Token is null.');

    var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadAvatar}'));
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData['data']['avatarUrl'];
      } else {
        throw ProfileException(responseData['message'] ?? 'Upload failed.');
      }
    } catch (e) { rethrow; }
  }

  // HÀM ĐƯỢC SỬA LẠI
  Future<Map<String, dynamic>> getUserDetails(int userId) async {
    final accessToken = await AuthService.getValidAccessToken();
    if (accessToken == null) throw ProfileException('Token is null.');

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfile(userId)}');
    final headers = {'Authorization': 'Bearer $accessToken'};

    try {
      final response = await http.get(uri, headers: headers);

      // BƯỚC 1: KIỂM TRA STATUS CODE TRƯỚC TIÊN
      if (response.statusCode != 200) {
        // Nếu không phải 200, ném lỗi với thông tin hữu ích
        throw ProfileException('Failed to load user details for ID $userId. Status code: ${response.statusCode}');
      }

      // BƯỚC 2: KIỂM TRA BODY RỖNG
      if (response.body.isEmpty) {
        throw ProfileException('Response body is empty for user ID $userId.');
      }
      
      // BƯỚC 3: DECODE MỘT CÁCH AN TOÀN
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;

    } on SocketException {
      throw ProfileException('No Internet connection.');
    } on TimeoutException {
      throw ProfileException('Connection to server timed out.');
    } on FormatException {
       throw ProfileException('Failed to parse server response. Check RAW BODY log.');
    } catch (e) {
      // Ném lại các lỗi khác (ví dụ: ProfileException đã được ném ở trên)
      rethrow;
    }
  }
}
