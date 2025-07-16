import '../core/api/api_client.dart';

class LoginService {
  // Login with email/phone and password
  static Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
    required String userType,
  }) async {
    try {
      final response = await ApiClient.post(
        '/rider/login',
        body: {
          'emailOrPhone': emailOrPhone,
          'password': password,
          'userType': userType,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
