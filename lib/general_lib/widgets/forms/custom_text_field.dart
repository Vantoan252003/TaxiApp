import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final bool isObscured;
  final bool isReadOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLength;
  final bool showVerifiedBadge;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.isObscured = false,
    this.isReadOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLength,
    this.showVerifiedBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTheme.body2.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGray,
              ),
            ),
            if (showVerifiedBadge) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successGreen.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 12,
                      color: AppTheme.successGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Đã xác thực',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isObscured,
          readOnly: isReadOnly,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: hintText ?? label,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            filled: isReadOnly,
            fillColor: isReadOnly ? AppTheme.lightGray.withOpacity(0.3) : null,
            counterText: '', // Hide counter
          ),
          style: AppTheme.body1.copyWith(
            color: isReadOnly ? AppTheme.mediumGray : AppTheme.primaryBlack,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
