import '../api/api_client.dart';

class RegistrationService {
  static Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/rider/register',
        body: {
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
