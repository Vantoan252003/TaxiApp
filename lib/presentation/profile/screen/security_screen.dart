import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/security_menu_item.dart';
import '../../auth/screen/change_password_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isEnabled = await authProvider.isBiometricEnabled();
    setState(() {
      _biometricEnabled = isEnabled;
    });
  }

  Future<void> _toggleBiometric() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (_biometricEnabled) {
        // Disable biometric
        await authProvider.disableBiometric();
        setState(() {
          _biometricEnabled = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã tắt đăng nhập sinh trắc học')),
          );
        }
      } else {
        // Enable biometric
        final success = await authProvider.enableBiometric();
        if (success) {
          setState(() {
            _biometricEnabled = true;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã bật đăng nhập sinh trắc học')),
            );
          }
        } else {
          if (mounted) {
            _showBiometricSetupDialog();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thiết lập sinh trắc học'),
        content: const Text(
          'Để sử dụng đăng nhập sinh trắc học, vui lòng:\n\n'
          '📱 **Android:**\n'
          '• Vào Cài đặt → Bảo mật → Dấu vân tay\n'
          '• Thiết lập ít nhất 1 dấu vân tay\n\n'
          '🍎 **iOS:**\n'
          '• Vào Cài đặt → Face ID & Mật khẩu\n'
          '• Thiết lập Face ID\n\n'
          'Sau đó quay lại và thử lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _toggleBiometric();
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Bảo mật',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SecurityMenuItem(
                    icon: Icons.fingerprint,
                    title: 'Đăng nhập bằng dấu vân tay/Face ID',
                    subtitle: _biometricEnabled
                        ? 'Đã bật'
                        : 'Sử dụng dấu vân tay hoặc Face ID để đăng nhập nhanh',
                    trailing: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Switch(
                            value: _biometricEnabled,
                            onChanged: (value) => _toggleBiometric(),
                            activeColor: AppTheme.primaryBlack,
                          ),
                    onTap: _isLoading ? null : _toggleBiometric,
                  ),
                  const Divider(height: 1, indent: 56),
                  SecurityMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Đổi mật khẩu',
                    subtitle: 'Thay đổi mật khẩu tài khoản',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SecurityMenuItem(
                    icon: Icons.phone_outlined,
                    title: 'Số điện thoại',
                    subtitle: 'Quản lý số điện thoại đăng nhập',
                    onTap: () {
                      // TODO: Navigate to phone management screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SecurityMenuItem(
                    icon: Icons.devices_outlined,
                    title: 'Thiết bị đã đăng nhập',
                    subtitle: 'Quản lý các thiết bị đang đăng nhập',
                    onTap: () {
                      // TODO: Navigate to devices screen
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SecurityMenuItem(
                    icon: Icons.history_outlined,
                    title: 'Lịch sử đăng nhập',
                    subtitle: 'Xem lịch sử đăng nhập gần đây',
                    onTap: () {
                      // TODO: Navigate to login history screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
