import '../core/api/api_client.dart';

class RegistrationService {
  static Future<Map<String, dynamic>> register({
    required String email,
    required String phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
  }) async {
    try {
      final response = await ApiClient.post(
        '/rider/register',
        body: {
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'userType': 'CUSTOMER'
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
