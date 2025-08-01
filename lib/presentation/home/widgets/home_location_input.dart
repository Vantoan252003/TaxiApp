import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

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
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _buildIcon(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 10),
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
            height: 4,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          Text(text, style: AppTheme.body2),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getTextStyle() {
    return AppTheme.body2.copyWith(color: AppTheme.lightGray, fontSize: 16);
  }
}
