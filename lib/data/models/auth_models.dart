class AuthRequest {
  final String phoneNumber;
  final String purpose;
  final String userType;

  const AuthRequest({
    required this.phoneNumber,
    required this.purpose,
    this.userType = 'CUSTOMER',
  });

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'purpose': purpose,
        'userType': userType,
      };
}

class OtpVerificationRequest {
  final String phoneNumber;
  final String otp;
  final String purpose;

  const OtpVerificationRequest({
    required this.phoneNumber,
    required this.otp,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'purpose': purpose,
      };
}

class LoginRequest {
  final String emailOrPhone;
  final String password;

  const LoginRequest({
    required this.emailOrPhone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'emailOrPhone': emailOrPhone,
        'password': password,
      };
}

class AuthResponse {
  final bool success;
  final String? message;
  final dynamic
      data; // Change from Map<String, dynamic>? to dynamic to handle both boolean and Map
  final String? timestamp;

  const AuthResponse({
    this.success = false,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      timestamp: json['timestamp'],
    );
  }

  // Helper methods to extract user data from data object
  String? get accessToken => _getDataValue<String>('accessToken');
  String? get refreshToken => _getDataValue<String>('refreshToken');
  String? get userId => _getDataValue<String>('userId');
  String? get email => _getDataValue<String>('email');
  String? get phoneNumber => _getDataValue<String>('phoneNumber');
  String? get tokenType => _getDataValue<String>('tokenType');
  int? get expiresIn => _getDataValue<int>('expiresIn');
  List<String>? get roles {
    if (data is Map<String, dynamic> && data['roles'] != null) {
      return List<String>.from(data['roles']);
    }
    return null;
  }

  String? get userType => _getDataValue<String>('userType');

  // Helper method to safely extract values from data
  T? _getDataValue<T>(String key) {
    if (data is Map<String, dynamic>) {
      return data[key] as T?;
    }
    return null;
  }

  // Helper method to check if data is a Map (for user data)
  bool get hasUserData => data is Map<String, dynamic>;
}

class OtpResponse {
  final String phoneNumber;
  final String? otp;
  final String purpose;
  final String userType;
  final String? message;

  const OtpResponse({
    required this.phoneNumber,
    this.otp,
    required this.purpose,
    required this.userType,
    this.message,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      phoneNumber: json['phoneNumber'] ?? '',
      otp: json['otp'],
      purpose: json['purpose'] ?? '',
      userType: json['userType'] ?? 'CUSTOMER',
      message: json['message'],
    );
  }
}
