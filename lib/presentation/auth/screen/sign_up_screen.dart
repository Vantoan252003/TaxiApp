import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/services/registration_service.dart';
import '../../common/widgets/forms/custom_text_field.dart';
import '../../common/widgets/forms/custom_button.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool isPhoneVerified;

  const SignUpScreen({
    super.key,
    this.phoneNumber,
    this.isPhoneVerified = false,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Validators
  final _nameValidator = NameValidator();
  final _passwordValidator = PasswordValidator();

  bool _isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null && widget.isPhoneVerified) {
      // Remove leading 0 for API format (API expects without 0)
      String phoneForApi = widget.phoneNumber!;
      if (phoneForApi.startsWith('0')) {
        phoneForApi = phoneForApi.substring(1);
      }
      _phoneController.text = phoneForApi;
    }

    // Reset loading state when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // Clear any temporary registration data when leaving the screen
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  'Đăng ký tài khoản',
                  style: AppTheme.heading1.copyWith(fontSize: 28),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Điền thông tin để tạo tài khoản mới',
                  style: AppTheme.body2.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),

                const SizedBox(height: 30),

                // Họ và Tên trên cùng một dòng
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        label: 'Họ',
                        hintText: 'Nhập họ',
                        validator: (value) =>
                            _nameValidator.validate(value ?? '').errorMessage,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        label: 'Tên',
                        hintText: 'Nhập tên',
                        validator: (value) =>
                            _nameValidator.validate(value ?? '').errorMessage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Phone Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Số điện thoại',
                      style: AppTheme.body2.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isPhoneVerified
                            ? AppTheme.backgroundColor
                            : AppTheme.primaryWhite,
                        border: Border.all(
                          color: AppTheme.borderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Country Code
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: AppTheme.borderColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              '+84',
                              style: AppTheme.body1.copyWith(
                                color: AppTheme.darkGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Phone Number (readonly if verified)
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              enabled:
                                  false, // always readonly if passed from OTP
                              style: AppTheme.body1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                hintText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Nhập lại mật khẩu',
                  hintText: 'Nhập lại mật khẩu',
                  isObscured: _isObscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mediumGray,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                CustomButton(
                  text: 'Đăng ký',
                  width: double.infinity,
                  isLoading: _isLoading,
                  onPressed: _handleSignUp,
                ),

                const SizedBox(height: 20),

                // Already have account
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có tài khoản? ',
                        style: AppTheme.body2.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đăng nhập',
                          style: AppTheme.body2.copyWith(
                            color: AppTheme.primaryBlack,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Terms and conditions
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Bằng việc đăng ký, bạn đồng ý với\nĐiều khoản sử dụng và Chính sách bảo mật',
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
          ),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await RegistrationService.register(
          phoneNumber: _phoneController.text
              .trim(), // luôn lấy từ controller, đã readonly
          password: _passwordController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          userType: 'CUSTOMER',
        );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công!'),
              backgroundColor: AppTheme.successGreen,
            ),
          );

          // Navigate to home screen directly
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
