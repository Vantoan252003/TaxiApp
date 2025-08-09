import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTheme.caption,
        children: [
          const TextSpan(text: 'Bằng việc tiếp tục, bạn đồng ý với '),
          TextSpan(
            text: 'Điều khoản dịch vụ',
            style: AppTheme.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),
          const TextSpan(text: ' và '),
          TextSpan(
            text: 'Chính sách bảo mật',
            style: AppTheme.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
