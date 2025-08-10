import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import '../../home/screen/home_screen.dart';
import '../../../core/constants/app_theme.dart';

class HandleSignIn {
  static void handleSignIn({
    required AuthProvider authProvider,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailOrPhoneController,
    required TextEditingController passwordController,
  }) async {
    if (formKey.currentState!.validate()) {
      String emailOrPhone = emailOrPhoneController.text.trim();
      if (RegExp(r'^0?\d+$').hasMatch(emailOrPhone)) {
        if (emailOrPhone.startsWith('0')) {
          emailOrPhone = emailOrPhone.substring(1);
        }
      }

      await authProvider.login(
        emailOrPhone: emailOrPhone,
        password: passwordController.text.trim(),
      );

      if (authProvider.state == AuthState.authenticated) {
        // Lưu số điện thoại từ form đăng nhập cho sinh trắc học
        final originalPhone = emailOrPhoneController.text.trim();
        await authProvider.savePhoneFromLoginForm(originalPhone);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
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
