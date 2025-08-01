import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api_endpoints.dart';
import '../../data/models/user_model.dart';

class GetUserinfoService {
  Future<UserModel?> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return null;
    }

    try {
      const String url = '${ApiEndpoints.baseUrl}${ApiEndpoints.me}';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, dynamic> userData;
        if (data['data'] != null) {
          userData = data['data'];
        } else if (data['user'] != null) {
          userData = data['user'];
        } else {
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
