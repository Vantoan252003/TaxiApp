class ApiEndpoints {
  // Base
  static const String baseUrl = 'https://gateway.soramall.co/api/v1';

  // rider endpoints
  static const String checkPhoneNumber = '/auth/rider/check-phone/{phoneNumber}';
  static const String sendOtp = '/rider/otp/send';
  static const String verifyOtp = '/rider/otp/verify';
  static const String login = '/auth/rider/login';
  static const String register = '/auth/rider/register';
  static const String logout = '/auth/rider/logout';
  static const String refreshToken = '/rider/refresh';
  static const String me = '/auth/rider/me';
  //search and filter
  static const String reverse = '/location/reverse';
  static const String autocomplete = '/location/autocomplete';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // Ride endpoints
  static const String createRide = '/rides';
  static const String getRides = '/rides';
  static const String getRideById = '/rides/{id}';
  static const String cancelRide = '/rides/{id}/cancel';
}
