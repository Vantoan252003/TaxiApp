import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class CheckPhoneService {
  static Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.checkPhoneNumber
            .replaceFirst('{phoneNumber}', phoneNumber),
      );
      if (response['data'] == true) {
        return true; // Phone number exists
      }
      return false;
    } catch (e) {
      throw 'Không thể kiểm tra số điện thoại. Vui lòng thử lại.';
    }
  }
}
