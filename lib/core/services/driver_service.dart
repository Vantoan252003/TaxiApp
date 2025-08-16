import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_exception.dart';
import '../../data/models/driver_model.dart';

class DriverService {
  static const String _accessTokenKey = 'accessToken';

  // Get access token from SharedPreferences
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<List<DriverModel>> findNearbyDrivers({
    required double lat,
    required double lng,
    required String vehicleType,
    int radiusMeters = 3000,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        return [];
      }

      final endpoint =
          '${ApiEndpoints.findNearby}?lat=${lat}&lng=${lng}&vehicleType=${vehicleType}&radiusMeters=${radiusMeters}';

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await ApiClient.get(endpoint, headers: headers);

      // Handle response that can be List or Map
      if (response is List) {
        return response.map((json) => DriverModel.fromJson(json)).toList();
      } else if (response is Map) {
        if (response.containsKey('success') && response['success'] == false) {
          return [];
        }

        if (response.containsKey('data')) {
          final data = response['data'];

          if (data is List) {
            return data.map((json) => DriverModel.fromJson(json)).toList();
          } else if (data is Map) {
            if (data.containsKey('drivers') && data['drivers'] is List) {
              final driversList = data['drivers'] as List;
              return driversList
                  .map((json) => DriverModel.fromJson(json))
                  .toList();
            }
          }
        }
      }

      return [];
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: $e');
    }
  }

  /// Find nearby motorcycle drivers (shorthand method)
  static Future<List<DriverModel>> findNearbyMotorcycles({
    required double lat,
    required double lng,
    int radiusMeters = 3000,
  }) {
    return findNearbyDrivers(
      lat: lat,
      lng: lng,
      vehicleType: 'MOTORCYCLE',
      radiusMeters: radiusMeters,
    );
  }

  static Future<List<DriverModel>> findNearbyCars({
    required double lat,
    required double lng,
    int radiusMeters = 3000,
  }) {
    return findNearbyDrivers(
      lat: lat,
      lng: lng,
      vehicleType: 'CAR',
      radiusMeters: radiusMeters,
    );
  }
}
