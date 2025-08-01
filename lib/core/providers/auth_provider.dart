import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/auth_models.dart';
import '../../domain/usecase/auth_usecases.dart';
import '../services/service_locator.dart';
import '../services/check_phone_service.dart';
import '../services/get_userinfo_service.dart';
import '../services/biometric_service.dart';
import '../services/location_cache_service.dart';
import '../../data/models/user_model.dart';

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

  // Kiểm tra xem có session người dùng được lưu không
  Future<bool> hasStoredSession() async {
    final user = await _getCurrentUserFromStorage();
    return user != null;
  }

  // Initialize authentication state from SharedPreferences
  Future<void> _initializeAuth() async {
    try {
      final user = await _getCurrentUserFromStorage();
      if (user != null) {
        // Check if user has completed registration (has firstName, lastName, etc.)
        final isRegistrationComplete = _isRegistrationComplete(user);

        if (isRegistrationComplete) {
          _currentUser = user;
          _setState(AuthState.authenticated);
        } else {
          // User exists but registration is incomplete, clear storage and show as unauthenticated

          await _clearUserFromStorage();
          await _clearAccessToken();
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setState(AuthState.unauthenticated);
    }
  }

  // Check if user registration is complete
  bool _isRegistrationComplete(UserModel user) {
    // For auto-login, we only need basic user info (userId, email, phoneNumber)
    // firstName and lastName are optional and can be filled later
    // isVerified can be null (assume verified if not specified)
    // If user has accessToken, they are considered authenticated
    final hasBasicInfo = user.userId.isNotEmpty &&
        (user.email.isNotEmpty || user.phoneNumber.isNotEmpty);

    final isVerified = user.isVerified == null || user.isVerified == true;
    final hasAccessToken =
        user.accessToken != null && user.accessToken!.isNotEmpty;

    // User is complete if they have basic info AND (are verified OR have access token)
    return hasBasicInfo && (isVerified || hasAccessToken);
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
        // For registration, don't save user data yet - wait for complete registration
        // Just mark as initial state to proceed to sign up screen
        _setState(AuthState.initial);
      } else {
        // For login, save user data and mark as authenticated
        if (response.hasUserData) {
          final user =
              UserModel.fromJson(response.data as Map<String, dynamic>);
          await _saveUserToStorage(user);
          _currentUser = user;
          _setState(AuthState.authenticated);
        }
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

      if (response.hasUserData) {
        final user = UserModel.fromJson(response.data as Map<String, dynamic>);

        await _saveUserToStorage(user);

        // Lưu accessToken riêng để sử dụng cho API calls
        if (user.accessToken != null) {
          await _saveAccessToken(user.accessToken!);

          // Cache current location after successful login
          _cacheCurrentLocationInBackground();
        } else {}

        _currentUser = user;
        _setState(AuthState.authenticated);
      } else {
        _setError('Login failed: No user data received');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Load user info from API
  Future<void> loadUserInfo() async {
    if (_currentUser == null) {
      return;
    }

    
   

    final service = GetUserinfoService();
    final userInfo = await service.fetchUserInfo();

    if (userInfo != null) {
      _currentUser = userInfo;
      await _saveUserToStorage(userInfo);
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout({bool clearBiometric = false}) async {
    if (clearBiometric) {
      // Nếu logout hoàn toàn (không dùng sinh trắc học), xóa tất cả dữ liệu
      await _clearUserFromStorage();
      await _clearAccessToken();
      await disableBiometric();
      _authResponse = null;
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } else {
      // Nếu chỉ logout tạm thời (giữ dữ liệu cho sinh trắc học), chỉ thay đổi trạng thái
      _setState(AuthState.unauthenticated);
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(AuthState.initial);
    }
  }

  // Save user data after successful registration
  Future<void> saveUserAfterRegistration(Map<String, dynamic> userData) async {
    try {
      final user = UserModel.fromJson(userData);
      await _saveUserToStorage(user);
      _currentUser = user;
      _setState(AuthState.authenticated);
    } catch (e) {
      _setError('Failed to save user data: $e');
    }
  }

  // Private methods for SharedPreferences
  static const String _userKey = 'currentUser';
  static const String _accessTokenKey = 'accessToken';
  static const String _biometricEnabledKey = 'biometricEnabled';

  Future<void> _saveUserToStorage(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    final userString = jsonEncode(userJson);

    await prefs.setString(_userKey, userString);
  }

  Future<void> _saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  void _cacheCurrentLocationInBackground() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      await LocationCacheService.updateAndCacheCurrentLocation();
    });
  }

  Future<UserModel?> _getCurrentUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      try {
        final userJson = jsonDecode(userString);

        final user = UserModel.fromJson(userJson);

        // Load accessToken from separate storage and assign to user
        final accessToken = prefs.getString(_accessTokenKey);

        if (accessToken != null && accessToken.isNotEmpty) {
          // Create a new user with accessToken
          final userWithToken = user.copyWith(accessToken: accessToken);

          return userWithToken;
        }

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

  Future<void> _clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }

  // Biometric authentication methods
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  Future<bool> enableBiometric() async {
    try {
      // Kiểm tra xem thiết bị có hỗ trợ sinh trắc học không
      final canUse = await BiometricService.canUseBiometric();
      if (!canUse) {
        throw Exception(
            'Thiết bị không hỗ trợ sinh trắc học hoặc chưa được thiết lập');
      }

      // Xác thực bằng sinh trắc học để bật tính năng
      final authenticated = await BiometricService.authenticate(
        reason: 'Xác thực để bật đăng nhập sinh trắc học',
      );

      if (authenticated) {
        // Lưu trạng thái bật sinh trắc học
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_biometricEnabledKey, true);
        return true;
      } else {
        throw Exception('Xác thực sinh trắc học thất bại - Vui lòng thử lại');
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, false);
  }

  Future<bool> authenticateWithBiometric() async {
    try {
      // Kiểm tra xem sinh trắc học có được bật không
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        return false;
      }

      // Xác thực bằng sinh trắc học
      final authenticated = await BiometricService.authenticate(
        reason: 'Đăng nhập bằng sinh trắc học',
      );

      if (authenticated) {
        // Nếu xác thực thành công, khôi phục session người dùng

        // Lấy thông tin người dùng từ SharedPreferences
        final user = await _getCurrentUserFromStorage();
        if (user != null) {
          // Khôi phục thông tin người dùng và access token
          _currentUser = user;

          // Kiểm tra và khôi phục access token
          final prefs = await SharedPreferences.getInstance();
          final accessToken = prefs.getString(_accessTokenKey);
          if (accessToken != null) {}

          // Cập nhật trạng thái thành authenticated
          _setState(AuthState.authenticated);

          // Tải lại thông tin người dùng từ API nếu cần
          await loadUserInfo();

          return true;
        } else {
          return false;
        }
      }

      return false;
    } catch (e) {
      return false;
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
