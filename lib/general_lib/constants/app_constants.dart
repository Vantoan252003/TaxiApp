// App Constants
class AppConstants {
  // App Info
  static const String appName = 'Taxi App';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.taxiapp.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // SharedPreferences Keys
  static const String hasLaunchedKey = 'has_launched_before';
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';

  // User Roles
  static const String userRole = 'user';
  static const String driverRole = 'driver';
  static const String vendorRole = 'vendor';

  // UI Constants
  static const double defaultPadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;

  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 1500);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
