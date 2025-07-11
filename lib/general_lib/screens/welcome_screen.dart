import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final Widget? homeScreen;

  const WelcomeScreen({super.key, this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(homeScreen: homeScreen);
  }
}
