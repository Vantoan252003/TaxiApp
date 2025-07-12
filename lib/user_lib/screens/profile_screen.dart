import 'package:flutter/material.dart';
import '../../general_lib/services/auth_service.dart';
import '../models/profile_models.dart';
import '../widgets/profile_header.dart';
import '../widgets/menu_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary user profile - later get from Firebase
    final profile = UserProfile(
      name: 'Sophia',
      rating: '4.98',
      badge: 'Gold',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(profile: profile),
            
            const SizedBox(height: 8),
            
            // Account Section
            MenuSection(
              title: 'Account',
              items: [
                MenuItem(
                  title: 'Payment methods',
                  icon: Icons.credit_card,
                  onTap: () {
                    // Navigate to payment methods
                  },
                ),
                MenuItem(
                  title: 'Wallet',
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    // Navigate to wallet
                  },
                ),
                MenuItem(
                  title: 'Ride Pass',
                  icon: Icons.card_membership,
                  onTap: () {
                    // Navigate to ride pass
                  },
                ),
                MenuItem(
                  title: 'Send a gift',
                  icon: Icons.card_giftcard,
                  onTap: () {
                    // Navigate to gift
                  },
                ),
                MenuItem(
                  title: 'Invite friends',
                  icon: Icons.person_add,
                  onTap: () {
                    // Navigate to invite friends
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Settings Section
            MenuSection(
              title: 'Settings',
              items: [
                MenuItem(
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                MenuItem(
                  title: 'Privacy Center',
                  icon: Icons.security,
                  onTap: () {
                    // Navigate to privacy center
                  },
                ),
                MenuItem(
                  title: 'Legal',
                  icon: Icons.description,
                  onTap: () {
                    // Navigate to legal
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Support Section
            MenuSection(
              title: 'Support',
              items: [
                MenuItem(
                  title: 'Help',
                  icon: Icons.help_outline,
                  onTap: () {
                    // Navigate to help
                  },
                ),
                MenuItem(
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await AuthService().signOut();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
