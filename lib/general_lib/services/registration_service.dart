import '../core/api/api_client.dart';

class RegistrationService {
  static Future<Map<String, dynamic>> register({
    required String email,
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await ApiClient.post(
        '/rider/register',
        body: {
          'email': email,
          'phone': phone,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
