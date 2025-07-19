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
  final String userType;

  const OtpVerificationRequest({
    required this.phoneNumber,
    required this.otp,
    required this.purpose,
    this.userType = 'CUSTOMER',
  });

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'purpose': purpose,
        'userType': userType,
      };
}

class LoginRequest {
  final String emailOrPhone;
  final String password;
  final String userType;

  const LoginRequest({
    required this.emailOrPhone,
    required this.password,
    this.userType = 'CUSTOMER',
  });

  Map<String, dynamic> toJson() => {
        'emailOrPhone': emailOrPhone,
        'password': password,
        'userType': userType,
      };
}

class AuthResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;
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
  String? get accessToken => data?['accessToken'];
  String? get refreshToken => data?['refreshToken'];
  String? get userId => data?['userId'];
  String? get email => data?['email'];
  String? get phoneNumber => data?['phoneNumber'];
  String? get tokenType => data?['tokenType'];
  int? get expiresIn => data?['expiresIn'];
  List<String>? get roles =>
      data?['roles'] != null ? List<String>.from(data!['roles']) : null;
  String? get userType => data?['userType'];
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
