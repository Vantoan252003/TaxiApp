import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

class CheckPhoneService {
  static Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.checkPhoneNumber.replaceFirst('{phoneNumber}', phoneNumber),
      );
      
      // API response: { "success": true, "message": "...", "data": true/false }
      if (response.containsKey('data')) {
        return response['data'] == true;
      }
      
      return false;
    } catch (e) {
      throw 'Không thể kiểm tra số điện thoại. Vui lòng thử lại.';
    }
  }
} 