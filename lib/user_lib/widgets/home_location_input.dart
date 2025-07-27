import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class HomeLocationInput extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLoading;
  final VoidCallback onTap;

  const HomeLocationInput({
    super.key,
    required this.icon,
    required this.text,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(child: _buildContent()),
            if (!isLoading) _buildTrailingIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppTheme.primaryBlack, size: 16),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(text, style: AppTheme.body2),
        ],
      );
    }

    return Text(text, style: _getTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis,);
  }

  TextStyle _getTextStyle() {
    final isPlaceholder = text.contains('Nhập vào') ||
        text.contains('Lỗi') ||
        text.contains('Đang lấy');
    return isPlaceholder
        ? AppTheme.body2.copyWith(color: AppTheme.lightGray)
        : AppTheme.body1
            .copyWith(color: AppTheme.darkGray, fontWeight: FontWeight.w500);
  }

  Widget _buildTrailingIcon() {
    return const Icon(
      Icons.more_vert,
      color: AppTheme.lightGray,
      size: 20,
    );
  }
}
