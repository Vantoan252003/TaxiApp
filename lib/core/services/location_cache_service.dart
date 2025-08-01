import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';

class LocationCacheService {
  static const String _currentAddressKey = 'current_address';
  static const String _currentLatKey = 'current_lat';
  static const String _currentLngKey = 'current_lng';
  static const String _lastUpdateTimeKey = 'last_update_time';

  // Cache current address
  static Future<void> cacheCurrentAddress({
    required String address,
    required double lat,
    required double lng,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAddressKey, address);
    await prefs.setDouble(_currentLatKey, lat);
    await prefs.setDouble(_currentLngKey, lng);
    await prefs.setInt(
        _lastUpdateTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Get cached current address
  static Future<String?> getCachedCurrentAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAddressKey);
  }

  // Get cached coordinates
  static Future<Map<String, double>?> getCachedCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_currentLatKey);
    final lng = prefs.getDouble(_currentLngKey);

    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
    return null;
  }

  // Check if cache is still valid (less than 5 minutes old)
  static Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateTimeKey);

    if (lastUpdate == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - lastUpdate;
    const fiveMinutes = 5 * 60 * 1000; // 5 minutes in milliseconds

    return difference < fiveMinutes;
  }

  // Clear cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentAddressKey);
    await prefs.remove(_currentLatKey);
    await prefs.remove(_currentLngKey);
    await prefs.remove(_lastUpdateTimeKey);
  }

  // Update current location and cache it
  static Future<String?> updateAndCacheCurrentLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position == null) return null;

    final reverseResponse = await LocationService.reverseGeocoding(
      lat: position.latitude,
      lng: position.longitude,
    );

    if (reverseResponse.success && reverseResponse.data.isNotEmpty) {
      final locationData = reverseResponse.data.first;
      final address = locationData.name;

      // Cache the result
      await cacheCurrentAddress(
        address: address,
        lat: position.latitude,
        lng: position.longitude,
      );

      return address;
    }

    return null;
  }

  // Get current address (from cache if valid, otherwise update)
  static Future<String?> getCurrentAddress() async {
    // Check if cache is valid
    if (await isCacheValid()) {
      final cachedAddress = await getCachedCurrentAddress();
      if (cachedAddress != null) {
        return cachedAddress;
      }
    }

    // Cache is invalid or empty, update it
    return await updateAndCacheCurrentLocation();
  }
}
