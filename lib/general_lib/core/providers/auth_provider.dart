import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import '../usecases/auth_usecases.dart';
import '../di/service_locator.dart';
import '../../services/check_phone_service.dart';
import '../../models/user_model.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  String? _errorMessage;
  AuthResponse? _authResponse;
  UserModel? _currentUser;

  // Use cases
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final LoginUseCase _loginUseCase;

  AuthProvider() {
    _sendOtpUseCase = ServiceLocator.instance.get<SendOtpUseCase>();
    _verifyOtpUseCase = ServiceLocator.instance.get<VerifyOtpUseCase>();
    _loginUseCase = ServiceLocator.instance.get<LoginUseCase>();
    _initializeAuth();
  }

  // Getters
  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isInitialized => _state != AuthState.initial;

  // Initialize authentication state from SharedPreferences
  Future<void> _initializeAuth() async {
    try {
      final user = await _getCurrentUserFromStorage();
      if (user != null) {
        _currentUser = user;
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setState(AuthState.unauthenticated);
    }
  }

  // Check if phone number exists
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    _setState(AuthState.loading);

    try {
      final exists =
          await CheckPhoneService.checkPhoneNumberExists(phoneNumber);
      _setState(AuthState.initial);
      return exists;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

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

      // Create AuthResponse from OtpResponse for consistency
      _authResponse = AuthResponse(
        success: true,
        message: response.message,
        data: {
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
        // For registration, save user data and mark as authenticated
        if (response.data != null) {
          final user = UserModel.fromJson(response.data!);
          await _saveUserToStorage(user);
          _currentUser = user;
          _setState(AuthState.authenticated);
        }
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

      // Save user data to SharedPreferences
      if (response.data != null) {
        final user = UserModel.fromJson(response.data!);
        await _saveUserToStorage(user);
        _currentUser = user;
        _setState(AuthState.authenticated);
      } else {
        _setError('Login failed: No user data received');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    await _clearUserFromStorage();
    _authResponse = null;
    _currentUser = null;
    _setState(AuthState.unauthenticated);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(AuthState.initial);
    }
  }

  // Private methods for SharedPreferences
  static const String _userKey = 'currentUser';

  Future<void> _saveUserToStorage(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> _getCurrentUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        final user = UserModel.fromJson(jsonDecode(userString));
        return user;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> _clearUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
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
