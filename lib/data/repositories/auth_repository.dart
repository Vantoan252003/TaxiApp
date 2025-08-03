import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/auth_models.dart';

abstract class AuthRepository {
  Future<OtpResponse> sendOtp(AuthRequest request);
  Future<AuthResponse> verifyOtp(OtpVerificationRequest request);
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> changePassword(
      ChangePasswordRequest request, String accessToken);
  Future<AuthResponse> updatePersonalInfo(
      UpdatePersonalInfoRequest request, String userId, String accessToken);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<OtpResponse> sendOtp(AuthRequest request) async {
    final response = await ApiClient.post(
      ApiEndpoints.sendOtp,
      body: request.toJson(),
    );
    return OtpResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> verifyOtp(OtpVerificationRequest request) async {
    final response = await ApiClient.post(
      ApiEndpoints.verifyOtp,
      body: request.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await ApiClient.post(
      ApiEndpoints.login,
      body: request.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> changePassword(
      ChangePasswordRequest request, String accessToken) async {
    final response = await ApiClient.put(
      ApiEndpoints.changePassword,
      body: request.toJson(),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> updatePersonalInfo(UpdatePersonalInfoRequest request,
      String userId, String accessToken) async {
    final endpoint = ApiEndpoints.updatePersonalInfo.replaceAll('{id}', userId);
    final response = await ApiClient.put(
      endpoint,
      body: request.toJson(),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return AuthResponse.fromJson(response);
  }
}
