// App Constants
class AppConstants {
  // App Info
  static const String appName = 'Mozi';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://gateway.soramall.co';
  static const Duration apiTimeout = Duration(seconds: 30);

  // SharedPreferences Keys
  static const String hasLaunchedKey = 'has_launched_before';
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';

  // User Roles
  static const String userRole = 'user';
  static const String driverRole = 'driver';
  static const String vendorRole = 'vendor';

  // Location Messages
  static const String loadingLocationText = 'Đang lấy vị trí...';
  static const String errorLocationText = 'Không thể lấy vị trí hiện tại';
  static const String destinationPlaceholder = 'Bạn muốn đi đâu ?';

  // Feature Messages
  static const String featureInDevelopment = 'đang phát triển';
  static const String destinationFeature = 'Chức năng chọn điểm đến';

  static const String defaultUserName = 'Người dùng';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double iconSize = 28.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;

  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 1500);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
