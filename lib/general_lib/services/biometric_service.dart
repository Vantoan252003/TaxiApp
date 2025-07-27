import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Kiểm tra xem thiết bị có hỗ trợ sinh trắc học không
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('BiometricService - Error checking biometric availability: $e');
      return false;
    }
  }

  // Lấy danh sách các loại sinh trắc học có sẵn
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics;
    } on PlatformException catch (e) {
      print('BiometricService - Error getting available biometrics: $e');
      return [];
    }
  }

  // Xác thực bằng sinh trắc học
  static Future<bool> authenticate({
    String reason = 'Vui lòng xác thực để tiếp tục',
    String cancelButton = 'Hủy',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        print('BiometricService - Biometric authentication not available');
        return false;
      }

      print('BiometricService - Starting authentication with reason: $reason');

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      print('BiometricService - Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      print(
          'BiometricService - Authentication error: ${e.code} - ${e.message}');

      // Xử lý các lỗi cụ thể
      switch (e.code) {
        case 'NotAvailable':
          print('BiometricService - Biometric not available on this device');
          break;
        case 'NotEnrolled':
          print('BiometricService - No biometric enrolled on this device');
          break;
        case 'PasscodeNotSet':
          print('BiometricService - Passcode not set on this device');
          break;
        case 'LockedOut':
          print('BiometricService - Biometric is locked out');
          break;
        case 'UserCancel':
          print('BiometricService - User cancelled authentication');
          break;
        default:
          print('BiometricService - Unknown error: ${e.code}');
      }

      return false;
    } catch (e) {
      print('BiometricService - General error: $e');
      return false;
    }
  }

  // Lấy tên loại sinh trắc học để hiển thị
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Dấu vân tay';
      case BiometricType.iris:
        return 'Mống mắt';
      default:
        return 'Sinh trắc học';
    }
  }

  // Lấy tên loại sinh trắc học chính (ưu tiên Face ID trên iOS, fingerprint trên Android)
  static Future<String> getPrimaryBiometricTypeName() async {
    final availableBiometrics = await getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Dấu vân tay';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Mống mắt';
    }

    return 'Sinh trắc học';
  }

  // Kiểm tra xem có thể sử dụng sinh trắc học không
  static Future<bool> canUseBiometric() async {
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) return false;

    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }
}
