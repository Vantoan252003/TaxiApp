import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/general_lib/constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class GetUserinfoService {
  Future<UserModel?> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return null;
    }

    try {
      const String url = '${AppConstants.baseUrl}/api/v1/auth/rider/me';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Xử lý response structure có thể khác nhau
        Map<String, dynamic> userData;
        if (data['data'] != null) {
          // Nếu response có structure: { "data": { ... } }
          userData = data['data'];
        } else if (data['user'] != null) {
          // Nếu response có structure: { "user": { ... } }
          userData = data['user'];
        } else {
          // Nếu response trực tiếp là user data
          userData = data;
        }

        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
