import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../core/providers/auth_provider.dart';
import '../core/validators/form_validators.dart';
import '../widgets/forms/otp_input_field.dart';
import '../widgets/forms/custom_button.dart';
import 'sign_up_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String purpose;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.purpose = 'REGISTRATION',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  final _otpValidator = OtpValidator();
  Timer? _timer;
  int _countDown = 60;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountDown() {
    _countDown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_countDown > 0) {
          setState(() {
            _countDown--;
          });
        } else {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Xác thực OTP',
                    style: AppTheme.heading1.copyWith(fontSize: 28),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  RichText(
                    text: TextSpan(
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                      children: [
                        const TextSpan(text: 'Mã OTP đã được gửi đến số '),
                        TextSpan(
                          text: '+84${widget.phoneNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // OTP Input Fields
                  OtpInputField(
                    controllers: _otpControllers,
                    focusNodes: _focusNodes,
                    onChanged: (value) {
                      // Clear errors when user starts typing
                      if (authProvider.errorMessage != null) {
                        authProvider.clearError();
                      }
                    },
                    onCompleted: () => _handleVerifyOtp(authProvider),
                  ),

                  const SizedBox(height: 40),

                  // Verify Button
                  CustomButton(
                    text: 'Xác thực',
                    width: double.infinity,
                    isLoading: authProvider.isLoading,
                    onPressed: () => _handleVerifyOtp(authProvider),
                  ),

                  const SizedBox(height: 24),

                  // Resend OTP
                  Center(
                    child: _countDown > 0
                        ? Text(
                            'Gửi lại mã sau ${_countDown}s',
                            style: AppTheme.body2.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          )
                        : CustomButton(
                            text: 'Gửi lại mã OTP',
                            type: CustomButtonType.text,
                            isLoading: _isResending,
                            onPressed: () => _handleResendOtp(authProvider),
                          ),
                  ),

                  const Spacer(),

                  // Help text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Không nhận được mã? Kiểm tra tin nhắn hoặc thử gửi lại',
                        textAlign: TextAlign.center,
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleVerifyOtp(AuthProvider authProvider) async {
    // Get OTP from controllers
    final otp = _otpControllers.map((controller) => controller.text).join();

    // Validate OTP
    final validationResult = _otpValidator.validate(otp);
    if (!validationResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationResult.errorMessage!),
          backgroundColor: AppTheme.warningRed,
        ),
      );
      return;
    }

    await authProvider.verifyOtp(
      phoneNumber: widget.phoneNumber,
      otp: otp,
      purpose: widget.purpose,
    );

    if (mounted) {
      if (authProvider.state == AuthState.authenticated) {
        // Navigate to home screen for login
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else if (authProvider.state != AuthState.error) {
        // Navigate to sign up screen for registration
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phoneNumber: widget.phoneNumber,
              isPhoneVerified: true,
            ),
          ),
        );
      } else if (authProvider.errorMessage != null) {
        // Clear OTP fields on error
        for (var controller in _otpControllers) {
          controller.clear();
        }
        FocusScope.of(context).requestFocus(_focusNodes[0]);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppTheme.warningRed,
          ),
        );
        authProvider.clearError();
      }
    }
  }

  void _handleResendOtp(AuthProvider authProvider) async {
    setState(() {
      _isResending = true;
    });

    await authProvider.sendOtp(
      phoneNumber: widget.phoneNumber,
      purpose: widget.purpose,
    );

    if (mounted) {
      setState(() {
        _isResending = false;
      });

      if (authProvider.state != AuthState.error) {
        // Clear existing OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        FocusScope.of(context).requestFocus(_focusNodes[0]);

        // Restart countdown
        _startCountDown();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mã OTP mới đã được gửi'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppTheme.warningRed,
          ),
        );
        authProvider.clearError();
      }
    }
  }
}
