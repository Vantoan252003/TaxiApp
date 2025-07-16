import 'package:flutter/foundation.dart';
import '../models/auth_models.dart';
import '../usecases/auth_usecases.dart';
import '../di/service_locator.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  String? _errorMessage;
  AuthResponse? _authResponse;

  // Use cases
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final LoginUseCase _loginUseCase;

  AuthProvider() {
    _sendOtpUseCase = ServiceLocator.instance.get<SendOtpUseCase>();
    _verifyOtpUseCase = ServiceLocator.instance.get<VerifyOtpUseCase>();
    _loginUseCase = ServiceLocator.instance.get<LoginUseCase>();
  }

  // Getters
  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  // Send OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required String purpose,
  }) async {
    _setState(AuthState.loading);

    try {
      final response = await _sendOtpUseCase.execute(
        phoneNumber: phoneNumber,
        purpose: purpose,
      );

      _authResponse = AuthResponse(
        message: response.message,
        user: {
          'phoneNumber': response.phoneNumber,
          'purpose': response.purpose,
        },
      );

      _setState(AuthState.initial);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Verify OTP
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String purpose,
  }) async {
    _setState(AuthState.loading);

    try {
      final response = await _verifyOtpUseCase.execute(
        phoneNumber: phoneNumber,
        otp: otp,
        purpose: purpose,
      );

      _authResponse = response;

      if (purpose == 'REGISTRATION') {
        // For registration, just mark as verified but not authenticated
        _setState(AuthState.initial);
      } else {
        // For login, mark as authenticated
        _setState(AuthState.authenticated);
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Login
  Future<void> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _setState(AuthState.loading);

    try {
      final response = await _loginUseCase.execute(
        emailOrPhone: emailOrPhone,
        password: password,
      );

      _authResponse = response;
      _setState(AuthState.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Logout
  void logout() {
    _authResponse = null;
    _setState(AuthState.unauthenticated);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(AuthState.initial);
    }
  }

  // Private methods
  void _setState(AuthState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _state = AuthState.error;
    _errorMessage = error;
    notifyListeners();
  }
}
