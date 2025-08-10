import 'package:shared_preferences/shared_preferences.dart';

class BiometricPhoneService {
  static const String _biometricPhoneKey = 'biometric_phone_number';

  /// Lưu số điện thoại khi sinh trắc học được bật
  static Future<void> saveBiometricPhone(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_biometricPhoneKey, phoneNumber);
    print('DEBUG: BiometricPhoneService - Đã lưu số điện thoại: $phoneNumber');
  }

  /// Lấy số điện thoại đã lưu cho sinh trắc học
  static Future<String?> getBiometricPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(_biometricPhoneKey);
    print('DEBUG: BiometricPhoneService - Lấy số điện thoại: $phone');
    return phone;
  }

  /// Xóa số điện thoại đã lưu (khi tắt sinh trắc học hoặc logout hoàn toàn)
  static Future<void> clearBiometricPhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricPhoneKey);
  }

  /// Kiểm tra xem có số điện thoại được lưu cho sinh trắc học không
  static Future<bool> hasBiometricPhone() async {
    final phone = await getBiometricPhone();
    return phone != null && phone.isNotEmpty;
  }
}
