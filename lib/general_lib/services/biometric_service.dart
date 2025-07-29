import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Kiểm tra xem thiết bị có hỗ trợ sinh trắc học không
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    }  catch (e) {
      return false;
    }
  }

  // Lấy danh sách các loại sinh trắc học có sẵn
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics;
    } catch (e) {
      return [];
    }
  }

  // Xác thực bằng sinh trắc học
  static Future<bool> authenticate({
    String reason = 'Vui lòng xác thực để tiếp tục',
    String cancelButton = 'Hủy',
  }) async {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return result;
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
