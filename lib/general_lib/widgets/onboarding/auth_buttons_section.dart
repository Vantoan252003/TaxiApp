import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class AuthButtonsSection extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onLogInPressed;

  const AuthButtonsSection({
    super.key,
    required this.onSignUpPressed,
    required this.onLogInPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSignUpPressed,
            style: AppTheme.primaryButtonStyle,
            child: const Text('Đăng ký'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onLogInPressed,
            style: AppTheme.secondaryButtonStyle,
            child: const Text('Đăng nhập'),
          ),
        ),
      ],
    );
  }
}
