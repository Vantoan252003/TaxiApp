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
  final String? token;
  final String? refreshToken;
  final Map<String, dynamic>? user;
  final String? message;

  const AuthResponse({
    this.token,
    this.refreshToken,
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: json['user'],
      message: json['message'],
    );
  }
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
