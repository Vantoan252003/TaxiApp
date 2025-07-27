import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      const StatItem(
        title: 'Chuyến xe',
        value: '12',
        icon: Icons.directions_car,
        color: Color(0xFF4ECDC4),
      ),
      const StatItem(
        title: 'Điểm tích',
        value: '1,250',
        icon: Icons.stars,
        color: Color(0xFFFFD93D),
      ),
      const StatItem(
        title: 'Tiết kiệm',
        value: '45k',
        icon: Icons.savings,
        color: Color(0xFF6BCF7F),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: stats.map((stat) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.subtleCardDecoration,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: stat.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      stat.icon,
                      color: stat.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat.value,
                    style: AppTheme.heading3.copyWith(
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.title,
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
