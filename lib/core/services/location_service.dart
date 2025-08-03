import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_endpoints.dart';
import '../api/api_client.dart';
import '../../data/models/place_model.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const String _baseUrl = ApiEndpoints.baseUrl;
  static const String _accessTokenKey = 'accessToken';

  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  // Get access token from SharedPreferences
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Reverse geocoding - convert coordinates to address
  static Future<ReverseGeocodingResponse> reverseGeocoding({
    required double lat,
    required double lng,
  }) async {
    try {
      final accessToken = await _getAccessToken();

      final endpoint = '${ApiEndpoints.reverse}?lat=$lat&lng=$lng';
      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await ApiClient.get(endpoint, headers: headers);
      return ReverseGeocodingResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error calling reverse geocoding API: $e');
    }
  }

  // Search places with autocomplete
  static Future<AutocompleteResponse> searchPlaces(String query) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception(
            'Access token not found. User may not be authenticated.');
      }

      // Get current position for focus parameter
      final currentPosition = await getCurrentPosition();
      String endpoint =
          '${ApiEndpoints.autocomplete}?text=${Uri.encodeComponent(query)}';

      // Add focus parameter if we have current position
      if (currentPosition != null) {
        final focus =
            '${currentPosition.latitude},${currentPosition.longitude}';
        endpoint +=
            '&focus=${Uri.encodeComponent(focus)}&circleRadius=100000&circleCenter=${Uri.encodeComponent(focus)}';
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await ApiClient.get(endpoint, headers: headers);
      return AutocompleteResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error calling autocomplete API: $e');
    }
  }

  // Get place details by refId
  static Future<PlaceDetailResponse> getPlaceDetail(String refId) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token is null or empty');
    }

    final endpoint =
        '${ApiEndpoints.place}?refid=${Uri.encodeComponent(refId)}';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await ApiClient.get(endpoint, headers: headers);

    return PlaceDetailResponse.fromJson(response);
  }
}
