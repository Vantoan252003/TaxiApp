import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../core/providers/auth_provider.dart';
import '../core/validators/form_validators.dart';
import '../widgets/forms/custom_text_field.dart';
import '../widgets/forms/custom_button.dart';
import '../widgets/biometric_login_button.dart';
import '../../user_lib/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  final String? prefillPhone;
  const SignInScreen({super.key, this.prefillPhone});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailOrPhoneValidator = EmailOrPhoneValidator();
  final _passwordValidator = PasswordValidator();

  bool _isObscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.prefillPhone != null && widget.prefillPhone!.isNotEmpty) {
      _emailOrPhoneController.text = widget.prefillPhone!;
    }
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Đăng nhập',
                      style: AppTheme.heading1.copyWith(fontSize: 28),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Nhập thông tin đăng nhập để tiếp tục',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email/Phone Field
                    CustomTextField(
                      controller: _emailOrPhoneController,
                      label: 'Email hoặc số điện thoại',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _emailOrPhoneValidator
                          .validate(value ?? '')
                          .errorMessage,
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      isObscured: _isObscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.mediumGray,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                      ),
                      validator: (value) =>
                          _passwordValidator.validate(value ?? '').errorMessage,
                    ),

                    const SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        text: 'Quên mật khẩu?',
                        type: CustomButtonType.text,
                        onPressed: () {
                          // Handle forgot password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Tính năng quên mật khẩu sẽ được cập nhật'),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Sign In Button
                    CustomButton(
                      text: 'Đăng nhập',
                      width: double.infinity,
                      isLoading: authProvider.isLoading,
                      onPressed: () => _handleSignIn(authProvider),
                    ),

                    const SizedBox(height: 20),

                    // Biometric Login Button
                    BiometricLoginButton(
                      onSuccess: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      onError: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đăng nhập sinh trắc học thất bại'),
                            backgroundColor: AppTheme.warningRed,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Don't have account
                    Center(
                      child: CustomButton(
                        text: 'Bạn chưa có tài khoản? Quay lại để đăng ký',
                        type: CustomButtonType.text,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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

  void _handleSignIn(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      String emailOrPhone = _emailOrPhoneController.text.trim();

      // Process phone number format for API
      // If it's a phone number (contains only digits), remove leading 0
      if (RegExp(r'^0?\d+$').hasMatch(emailOrPhone)) {
        // Remove leading 0 if exists for API format
        if (emailOrPhone.startsWith('0')) {
          emailOrPhone = emailOrPhone.substring(1);
        }
      }
      // If it's email, keep as is

      await authProvider.login(
        emailOrPhone: emailOrPhone,
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        if (authProvider.state == AuthState.authenticated) {
          // Navigate to home screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else if (authProvider.errorMessage != null) {
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
