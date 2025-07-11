import 'package:flutter/material.dart';
import '../widgets/onboarding/app_header_section.dart';
import '../widgets/onboarding/auth_buttons_section.dart';
import '../widgets/onboarding/terms_and_privacy_text.dart';
import '../services/first_launch_service.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final Widget? homeScreen;

  const OnboardingScreen({super.key, this.homeScreen});

  Future<void> _markAsLaunched() async {
    await FirstLaunchService.markAsLaunched();
  }

  void _navigateToHome(BuildContext context) {
    if (homeScreen != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => homeScreen!),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    // Navigate to Sign Up screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  Future<void> _handleLogIn(BuildContext context) async {
    // Navigate to Sign In screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              const AppHeaderSection(),
              const SizedBox(height: 40),
              AuthButtonsSection(
                onSignUpPressed: () => _handleSignUp(context),
                onLogInPressed: () => _handleLogIn(context),
              ),

              const SizedBox(height: 24),

              // Terms and Privacy Text
              const TermsAndPrivacyText(),
            ],
          ),
        ),
      ),
    );
  }
}
