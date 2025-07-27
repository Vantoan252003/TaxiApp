import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationCacheService {
  static const String _locationKey = 'cached_location';
  static const String _timestampKey = 'location_timestamp';
  static const int _cacheExpiryHours = 1; // Cache expires after 1 hour

  /// Cache location data
  static Future<void> cacheLocation(
      String address, double latitude, double longitude) async {
      final prefs = await SharedPreferences.getInstance();
      final locationData = {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await prefs.setString(_locationKey, jsonEncode(locationData));
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    
  }

  /// Get cached location if still valid
  static Future<Map<String, dynamic>?> getCachedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationJson = prefs.getString(_locationKey);
      final timestamp = prefs.getInt(_timestampKey);

      if (locationJson == null || timestamp == null) {
        return null;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = now - timestamp;
      final cacheExpiryMs = _cacheExpiryHours * 60 * 60 * 1000;

      if (cacheAge > cacheExpiryMs) {
        // Cache expired, clear it
        await clearCache();
        return null;
      }

      return jsonDecode(locationJson);
    } catch (e) {
      return null;
    }
  }

  /// Clear cached location
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_locationKey);
      await prefs.remove(_timestampKey);
    } catch (e) {
      // Silent fail
    }
  }

  /// Check if cache exists and is valid
  static Future<bool> hasValidCache() async {
    final cached = await getCachedLocation();
    return cached != null;
  }
}
