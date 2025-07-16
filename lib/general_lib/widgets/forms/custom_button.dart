import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

enum CustomButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = _buildButtonChild();

    switch (type) {
      case CustomButtonType.primary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppTheme.primaryButtonStyle,
            child: buttonChild,
          ),
        );
      case CustomButtonType.secondary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppTheme.secondaryButtonStyle,
            child: buttonChild,
          ),
        );
      case CustomButtonType.outline:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryBlack),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: buttonChild,
          ),
        );
      case CustomButtonType.text:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: AppTheme.textButtonStyle,
            child: buttonChild,
          ),
        );
    }
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
