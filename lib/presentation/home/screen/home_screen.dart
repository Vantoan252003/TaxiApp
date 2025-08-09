import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../user_lib/widgets/custom_bottom_navigation_bar.dart';
import '../controllers/home_controller.dart';
import 'main_home_screen.dart';
import '../../ride/screen/rides_screen.dart';
import '../../../user_lib/screens/wallet_screen.dart';
import '../../history/screen/activity_screen.dart';
import '../../profile/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;

  final List<Widget> _screens = [
    const MainHomeScreen(),
    const RidesScreen(),
    const WalletScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: _screens[_controller.currentIndex],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _controller.currentIndex,
            onTap: _controller.setCurrentIndex,
          ),
        );
      },
    );
  }
}
