import 'package:flutter/material.dart';
import '../services/first_launch_service.dart';
import '../services/auth_service.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import 'welcome_screen.dart';
import '../../user_lib/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  final Widget homeScreen;

  const SplashScreen({
    super.key,
    required this.homeScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Add a small delay for splash effect
    await Future.delayed(AppConstants.splashDuration);

    // Check if user is already logged in
    final authService = AuthService();
    final currentUser = authService.currentUser;

    if (mounted) {
      if (currentUser != null) {
        // User is logged in, go directly to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        // User is not logged in, check if it's first launch
        final isFirstLaunch = await FirstLaunchService.isFirstLaunch();

        if (mounted) {
          if (isFirstLaunch) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    WelcomeScreen(homeScreen: widget.homeScreen),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => widget.homeScreen,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo container with subtle animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlack,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlack.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_taxi,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // App name with fade animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    AppConstants.appName,
                    style: AppTheme.heading1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Tagline
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'Chào mừng bạn đến với Mozi - Ứng dụng đặt taxi thông minh',
                    style: AppTheme.body1.copyWith(
                      fontSize: 16,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Loading indicator
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1400),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryBlack,
                      ),
                      strokeWidth: 2.5,
                      backgroundColor: AppTheme.borderColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
