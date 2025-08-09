import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/first_launch_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'welcome_screen.dart';
import '../../home/screen/home_screen.dart';

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

    if (mounted) {
      // Get auth provider from context
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Wait for auth provider to initialize
      while (!authProvider.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        if (authProvider.isAuthenticated) {
          // User is already authenticated, go to home screen
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
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Bo tròn với bán kính 25
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Tagline căn giữa
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'Mozi - Ứng dụng đặt xe thông minh',
                    textAlign: TextAlign.center,
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
