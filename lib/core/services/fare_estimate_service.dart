import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_endpoints.dart';
import '../api/api_client.dart';
import '../../data/models/fare_estimate_model.dart';

class FareEstimateService {
  static const String _accessTokenKey = 'accessToken';

  // Get access token from SharedPreferences
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get fare estimate
  static Future<FareEstimateResponse> getFareEstimate({
    required double pickupLat,
    required double pickupLng,
    required double destLat,
    required double destLng,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception(
            'Access token not found. User may not be authenticated.');
      }

      final endpoint =
          '${ApiEndpoints.estimate}?pickupLat=$pickupLat&pickupLng=$pickupLng&destLat=$destLat&destLng=$destLng';

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await ApiClient.get(endpoint, headers: headers);
      return FareEstimateResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error calling fare estimate API: $e');
    }
  }
}
