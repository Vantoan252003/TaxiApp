import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/core/providers/auth_provider.dart';
import '../../general_lib/screens/phone_input_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/logout_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            ProfileMenuSection(
              title: 'Tài khoản',
              items: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Thông tin cá nhân',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Bảo mật',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Thông báo',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            ProfileMenuSection(
              title: 'Hỗ trợ',
              items: [
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Trung tâm trợ giúp',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Liên hệ hỗ trợ',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.star_outline,
                  title: 'Đánh giá ứng dụng',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            ProfileMenuSection(
              title: 'Khác',
              items: [
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: 'Về chúng tôi',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Chính sách bảo mật',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  isDestructive: true,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await LogoutDialog.show(context);
    if (shouldLogout == true) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Use AuthProvider instead of AuthService
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PhoneInputScreen()),
          (route) => false,
        );
      }
    }
  }
}
