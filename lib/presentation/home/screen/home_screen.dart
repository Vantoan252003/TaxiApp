import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../user_lib/widgets/custom_bottom_navigation_bar.dart';
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
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MainHomeScreen(),
    const RidesScreen(),
    const WalletScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
