import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class HomeServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const HomeServiceItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(height: 10),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: AppTheme.primaryBlack, size: 28),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTheme.body2.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: AppTheme.darkGray,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
