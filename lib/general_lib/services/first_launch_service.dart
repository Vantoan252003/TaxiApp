import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class FirstLaunchService {
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(AppConstants.hasLaunchedKey) ?? false);
  }

  static Future<void> markAsLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.hasLaunchedKey, true);
  }
}
