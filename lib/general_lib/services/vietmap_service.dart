import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

class VietMapService {
  static const String _apiKey =
      '8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d';

  /// Lấy địa chỉ từ tọa độ sử dụng VietMap API
  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/reverse/v3?apikey=$_apiKey&lat=$latitude&lng=$longitude&detail=true');

      debugPrint('Calling VietMap reverse API: $url');
      final response = await http.get(url);
      debugPrint('VietMap reverse response status: ${response.statusCode}');
      debugPrint('VietMap reverse response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final result = data[0];

          if (result['display'] != null) {
            debugPrint('VietMap reverse address: ${result['display']}');
            return result['display'];
          }

          String detailedAddress = '';
          if (result['name'] != null && result['name'].toString().isNotEmpty) {
            detailedAddress += result['name'];
          }
          if (result['address'] != null) {
            if (detailedAddress.isNotEmpty) {
              detailedAddress += ', ';
            }
            detailedAddress += result['address'];
          }

          if (detailedAddress.isNotEmpty) {
            debugPrint('VietMap fallback address: $detailedAddress');
            return detailedAddress;
          }
        }
      }

      debugPrint('VietMap reverse API failed or returned no data');
      return null;
    } catch (e) {
      debugPrint('Error getting address from VietMap: $e');
      return null;
    }
  }

  /// Tìm kiếm địa điểm theo từ khóa
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/search/v3?apikey=$_apiKey&text=${Uri.encodeComponent(query)}');

      debugPrint('Calling VietMap search API: $url');
      final response = await http.get(url);
      debugPrint('VietMap search response status: ${response.statusCode}');
      debugPrint('VietMap search response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          debugPrint('VietMap search found ${data.length} results');
          return List<Map<String, dynamic>>.from(data);
        }
      }

      debugPrint('VietMap search API failed or returned no data');
      return [];
    } catch (e) {
      debugPrint('Error searching places from VietMap: $e');
      return [];
    }
  }

  /// Lấy địa chỉ hiện tại sử dụng VietMap
  static Future<String?> getCurrentAddress() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      debugPrint('Error getting current address from VietMap: $e');
      return null;
    }
  }

  /// Lấy thông tin chi tiết về một địa điểm
  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/place/v3?apikey=$_apiKey&ref_id=$placeId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting place details from VietMap: $e');
      return null;
    }
  }
}
