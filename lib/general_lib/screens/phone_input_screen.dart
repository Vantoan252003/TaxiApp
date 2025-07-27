import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../core/providers/auth_provider.dart';
import '../core/validators/form_validators.dart';
import '../widgets/forms/custom_text_field.dart';
import '../widgets/forms/custom_button.dart';
import 'otp_verification_screen.dart';
import 'sign_in_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  final String? prefillPhone;

  const PhoneInputScreen({super.key, this.prefillPhone});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneValidator = PhoneNumberValidator();

  @override
  void initState() {
    super.initState();
    // Prefill phone number if provided
    if (widget.prefillPhone != null && widget.prefillPhone!.isNotEmpty) {
      _phoneController.text = widget.prefillPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Title
                    Text(
                      'Nhập số điện thoại',
                      style: AppTheme.heading1.copyWith(fontSize: 28),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Chúng tôi sẽ gửi mã OTP để xác thực số điện thoại của bạn',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Phone Number Field
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+84',
                              style: AppTheme.body1.copyWith(
                                color: AppTheme.primaryBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 24,
                              width: 1,
                              color: AppTheme.lightGray,
                            ),
                          ],
                        ),
                      ),
                      validator: (value) =>
                          _phoneValidator.validate(value ?? '').errorMessage,
                      onChanged: (value) {
                        // Auto add 0 if user starts typing without 0
                        if (value.isNotEmpty && !value.startsWith('0')) {
                          _phoneController.text = '0$value';
                          _phoneController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _phoneController.text.length),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    // Continue Button
                    CustomButton(
                      text: 'Tiếp tục',
                      width: double.infinity,
                      isLoading: authProvider.isLoading,
                      onPressed: () => _handleSendOtp(authProvider),
                    ),

                    const Spacer(),

                    // Already have account option
                    Center(
                      child: CustomButton(
                        text: 'Bạn đã có tài khoản? Đăng nhập',
                        type: CustomButtonType.text,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Terms and conditions
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Bằng việc tiếp tục, bạn đồng ý với\nĐiều khoản sử dụng và Chính sách bảo mật',
                          textAlign: TextAlign.center,
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.mediumGray,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleSendOtp(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneController.text.trim();

      // Remove leading zero for API call
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }

      // Check if phone number exists
      final exists = await authProvider.checkPhoneNumberExists(phoneNumber);

      if (mounted) {
        if (exists) {
          // Phone number exists, navigate to login with pre-filled phone
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Số điện thoại đã đăng ký, vui lòng đăng nhập.'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignInScreen(prefillPhone: '0$phoneNumber'),
            ),
          );
        } else {
          // Phone number doesn't exist, send OTP for registration
          await authProvider.sendOtp(
            phoneNumber: phoneNumber,
            purpose: 'REGISTRATION',
          );

          if (mounted && authProvider.state != AuthState.error) {
            // Navigate to OTP verification screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  phoneNumber: phoneNumber,
                ),
              ),
            );
          } else if (mounted && authProvider.errorMessage != null) {
            // Show error message
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
  }
}
