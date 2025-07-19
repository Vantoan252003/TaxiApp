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
      // Thử với endpoint reverse để lấy thông tin chi tiết
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/reverse/v3?apikey=$_apiKey&lat=$latitude&lng=$longitude&detail=true');

      print('Calling VietMap API: $url');
      final response = await http.get(url);
      print('VietMap response status: ${response.statusCode}');
      print('VietMap response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // VietMap API trả về array, lấy phần tử đầu tiên
        if (data is List && data.isNotEmpty) {
          final result = data[0];

          // Sử dụng display name vì nó đã bao gồm cả tên đường và địa chỉ
          if (result['display'] != null) {
            print('VietMap detailed address: ${result['display']}');
            return result['display'];
          }

          // Fallback: tạo địa chỉ từ name và address
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
            print('VietMap fallback address: $detailedAddress');
            return detailedAddress;
          }
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
          'https://maps.vietmap.vn/api/search/v3?apikey=$_apiKey&text=${Uri.encodeComponent(query)}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
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
      print('Error getting place details from VietMap: $e');
      return null;
    }
  }
}
