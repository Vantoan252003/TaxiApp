import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/biometric_service.dart';

class BiometricLoginButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final String? title;

  const BiometricLoginButton({
    super.key,
    this.onSuccess,
    this.onError,
    this.title,
  });

  @override
  State<BiometricLoginButton> createState() => _BiometricLoginButtonState();
}

class _BiometricLoginButtonState extends State<BiometricLoginButton> {
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String _biometricTypeName = 'Sinh trắc học';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await BiometricService.canUseBiometric();
    final typeName = await BiometricService.getPrimaryBiometricTypeName();

    if (mounted) {
      setState(() {
        _isBiometricAvailable = isAvailable;
        _biometricTypeName = typeName;
      });
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_isBiometricAvailable) {
      widget.onError?.call();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Kiểm tra xem có session được lưu không
      final hasSession = await authProvider.hasStoredSession();
      if (!hasSession) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Không có thông tin đăng nhập được lưu. Vui lòng đăng nhập bằng mật khẩu trước.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        widget.onError?.call();
        return;
      }

      final success = await authProvider.authenticateWithBiometric();

      if (success) {
        widget.onSuccess?.call();
      } else {
        widget.onError?.call();
      }
    } catch (e) {
      widget.onError?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _authenticateWithBiometric,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                _biometricTypeName.contains('Face')
                    ? Icons.face
                    : Icons.fingerprint,
                size: 24,
              ),
        label: Text(
          widget.title ?? 'Đăng nhập bằng $_biometricTypeName',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryBlack,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
    );
  }
}
