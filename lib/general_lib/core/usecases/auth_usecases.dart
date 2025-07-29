import '../models/auth_models.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  Future<OtpResponse> execute({
    required String phoneNumber,
    required String purpose,
  }) async {
    final request = AuthRequest(
      phoneNumber: phoneNumber,
      purpose: purpose,
      userType: 'CUSTOMER',
    );
    return await _repository.sendOtp(request);
  }
}

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<AuthResponse> execute({
    required String phoneNumber,
    required String otp,
    required String purpose,
  }) async {
    final request = OtpVerificationRequest(
      phoneNumber: phoneNumber,
      otp: otp,
      purpose: purpose,
    );
    return await _repository.verifyOtp(request);
  }
}

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResponse> execute({
    required String emailOrPhone,
    required String password,
  }) async {
    final request = LoginRequest(
      emailOrPhone: emailOrPhone,
      password: password,
    );
    return await _repository.login(request);
  }
}
