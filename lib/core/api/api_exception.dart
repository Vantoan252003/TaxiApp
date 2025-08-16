class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(
    this.message, {
    this.statusCode,
    this.data,
  });

  // Getter để truy cập message từ response data
  String? get responseMessage {
    if (data is Map) {
      final body = data as Map;
      if (body.containsKey('message') && body['message'] != null) {
        return body['message'].toString();
      }
    }

    return null;
  }

  // Getter để kiểm tra có phải lỗi đăng nhập không
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  @override
  String toString() => message;
}
