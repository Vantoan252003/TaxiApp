import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String apiKey = '8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d';
  const String baseUrl = 'https://maps.vietmap.vn/api';

  // Test với tọa độ Hà Nội
  const double lat = 21.0285;
  const double lng = 105.8542;

  try {
    final url =
        Uri.parse('$baseUrl/geocode/v1/reverse?lat=$lat&lng=$lng&key=$apiKey');
    print('Testing VietMap API with URL: $url');

    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Parsed data: $data');

      if (data['status'] == 'OK' && data['data'] != null) {
        final result = data['data'];
        print('Address data: $result');

        if (result['display_name'] != null) {
          print('Display name: ${result['display_name']}');
        }

        if (result['address'] != null) {
          print('Address components: ${result['address']}');
        }
      }
    }
  } catch (e) {
    print('Error testing VietMap API: $e');
  }
}
