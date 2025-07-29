import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  static const String _baseUrl = 'https://gateway.soramall.co/api/v1/auth';
  static const Duration _timeout = Duration(seconds: 30);

  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http
          .put(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http.delete(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  // Handle response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else {
      throw ApiException(_getErrorMessage(response));
    }
  }

  // Handle errors
  static String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Lỗi kết nối. Vui lòng kiểm tra internet và thử lại.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Kết nối bị timeout. Vui lòng thử lại.';
    } else {
      return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
    }
  }

  // Get error message from response
  static String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('message')) {
        return body['message'];
      }
    } catch (e) {
      // If can't decode response, use default messages
    }

    switch (response.statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ.';
      case 401:
        return 'Không có quyền truy cập.';
      case 403:
        return 'Bị cấm truy cập.';
      case 404:
        return 'Không tìm thấy tài nguyên.';
      case 500:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      default:
        return 'Đã xảy ra lỗi. Vui lòng thử lại.';
    }
  }
}
