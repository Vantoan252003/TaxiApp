class ApiEndpoints {
  // Base
  static const String baseUrl = 'https://gateway.soramall.co/api/v1';

  // rider endpoints
  static const String checkPhoneNumber =
      '/auth/rider/check-phone/{phoneNumber}';
  static const String sendOtp = '/auth/rider/otp/send';
  static const String verifyOtp = '/auth/rider/otp/verify';
  static const String login = '/auth/rider/login';
  static const String register = '/auth/rider/register';
  static const String logout = '/auth/rider/logout';
  static const String refreshToken = '/rider/refresh';
  static const String me = '/auth/rider/me';
  //search and filter
  static const String reverse = '/location/reverse';
  static const String autocomplete = '/location/autocomplete';

  //personal info endpoints
  static const String updatePersonalInfo = '/auth/rider/{id}';
  static const String changePassword = '/auth/rider/change-password';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/prrofile';

  // Ride endpoints
  static const String createRide = '/rides';
  static const String cancelRide = '/rides/{id}/cancel';
  //booking endpoints
  static const String place = '/location/place';
  static const String route = '/location/route';
  static const String estimate = '/fare/estimate';
}
