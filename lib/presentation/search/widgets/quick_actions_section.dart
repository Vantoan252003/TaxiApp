import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onAddHome;
  final VoidCallback? onAddWork;
  final VoidCallback? onAddPlace;

  const QuickActionsSection({
    super.key,
    this.onAddHome,
    this.onAddWork,
    this.onAddPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            "Thêm nhà",
            Icons.home,
            onAddHome,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuickActionButton(
            "Thêm công ty",
            Icons.work,
            onAddWork,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuickActionButton(
            "Thêm địa điểm",
            Icons.place,
            onAddPlace,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      String text, IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
