class ApiEndpoints {
  // Base
  static const String baseUrl = 'https://gateway.soramall.co/api/v1';

  // rider endpoints
  static const String checkPhoneNumber = '/rider/check-phone/{phoneNumber}';
  static const String sendOtp = '/rider/otp/send';
  static const String verifyOtp = '/rider/otp/verify';
  static const String login = '/rider/login';
  static const String register = '/rider/register';
  static const String logout = '/rider/logout';
  static const String refreshToken = '/rider/refresh';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // Ride endpoints
  static const String createRide = '/rides';
  static const String getRides = '/rides';
  static const String getRideById = '/rides/{id}';
  static const String cancelRide = '/rides/{id}/cancel';
}
