import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class VietMapService {
  static const String _apiKey =
      '8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d';
  static const String _baseUrl = 'https://maps.vietmap.vn/api';

  /// Lấy địa chỉ từ tọa độ sử dụng VietMap API
  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/geocode/v1/reverse?lat=$latitude&lng=$longitude&key=$_apiKey');

      print('Calling VietMap API: $url');
      final response = await http.get(url);
      print('VietMap response status: ${response.statusCode}');
      print('VietMap response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['data'] != null) {
          final result = data['data'];

          // VietMap API trả về địa chỉ trong trường 'display_name'
          if (result['display_name'] != null) {
            print('VietMap address: ${result['display_name']}');
            return result['display_name'];
          }

          // Fallback: tạo địa chỉ từ các thành phần
          final address = result['address'] ?? {};
          final street = address['road'] ?? address['street'] ?? '';
          final ward = address['suburb'] ?? address['ward'] ?? '';
          final district =
              address['city_district'] ?? address['district'] ?? '';
          final city = address['city'] ?? address['state'] ?? '';

          List<String> addressParts = [];
          if (street.isNotEmpty) addressParts.add(street);
          if (ward.isNotEmpty) addressParts.add(ward);
          if (district.isNotEmpty) addressParts.add(district);
          if (city.isNotEmpty) addressParts.add(city);

          final fallbackAddress = addressParts.join(', ');
          print('VietMap fallback address: $fallbackAddress');
          return fallbackAddress;
        }
      }

      print('VietMap API failed or returned no data');
      return null;
    } catch (e) {
      print('Error getting address from VietMap: $e');
      return null;
    }
  }

  /// Tìm kiếm địa điểm theo từ khóa
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/geocode/v1/search?q=${Uri.encodeComponent(query)}&key=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      print('Error searching places from VietMap: $e');
      return [];
    }
  }

  /// Lấy địa chỉ hiện tại sử dụng VietMap
  static Future<String?> getCurrentAddress() async {
    try {
      // Lấy vị trí hiện tại
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Sử dụng VietMap để lấy địa chỉ
      return await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('Error getting current address from VietMap: $e');
      return null;
    }
  }

  /// Lấy thông tin chi tiết về một địa điểm
  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/geocode/v1/place?place_id=$placeId&key=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['data'] != null) {
          return data['data'];
        }
      }

      return null;
    } catch (e) {
      print('Error getting place details from VietMap: $e');
      return null;
    }
  }
}
