import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/core/providers/auth_provider.dart';
import '../../general_lib/screens/sign_in_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/logout_dialog.dart';
import 'personal_info_screen.dart';
import 'security_screen.dart';

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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PersonalInfoScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Bảo mật',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SecurityScreen(),
                      ),
                    );
                  },
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

      // Lấy số điện thoại của người dùng hiện tại trước khi logout
      String? userPhone;
      if (authProvider.currentUser != null) {
        userPhone = authProvider.currentUser!.phoneNumber;
        // Nếu số điện thoại có định dạng +84, chuyển về 0
        if (userPhone != null && userPhone.startsWith('+84')) {
          userPhone = '0${userPhone.substring(3)}';
        }
        // Nếu số điện thoại không có 0 ở đầu, thêm vào
        if (userPhone != null && !userPhone.startsWith('0')) {
          userPhone = '0$userPhone';
        }
      }

      // Kiểm tra xem sinh trắc học có được bật không
      final isBiometricEnabled = await authProvider.isBiometricEnabled();

      if (isBiometricEnabled) {
        // Nếu sinh trắc học được bật, chỉ logout tạm thời (giữ dữ liệu)
        await authProvider.logout(clearBiometric: false);
      } else {
        // Nếu không có sinh trắc học, logout hoàn toàn
        await authProvider.logout(clearBiometric: true);
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Điều hướng đến trang đăng nhập với số điện thoại được điền sẵn
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SignInScreen(prefillPhone: userPhone),
          ),
          (route) => false,
        );
      }
    }
  }
}
