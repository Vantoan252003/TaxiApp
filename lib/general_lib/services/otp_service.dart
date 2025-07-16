import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static const String _baseUrl = 'https://gateway.soramall.co/api/v1/rider/otp';

  // Send OTP
  static Future<Map<String, dynamic>> sendOtp({
    required String phoneNumber,
    required String purpose,
    required String userType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'purpose': purpose,
          'userType': userType,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Gửi OTP thất bại. Vui lòng thử lại.';
      }
    } catch (e) {
      throw 'Lỗi kết nối. Vui lòng kiểm tra internet và thử lại.';
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String purpose,
    required String userType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
          'purpose': purpose,
          'userType': userType,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'OTP không đúng. Vui lòng thử lại.';
      }
    } catch (e) {
      throw 'Lỗi xác thực OTP. Vui lòng thử lại.';
    }
  }
}
