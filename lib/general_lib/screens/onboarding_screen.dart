import 'package:flutter/material.dart';
import '../widgets/onboarding/app_header_section.dart';
import '../widgets/onboarding/terms_and_privacy_text.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import 'phone_input_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final Widget? homeScreen;

  const OnboardingScreen({super.key, this.homeScreen});

  Future<void> _handleGetStarted(BuildContext context) async {
    // Navigate to Phone Input screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PhoneInputScreen()),
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

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleGetStarted(context),
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('Bắt đầu'),
                ),
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
