import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        elevation: 0,
        title: const Text(
          'Chuyến đi',
          style: AppTheme.heading3,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: AppTheme.mediumGray,
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có chuyến đi nào',
              style: AppTheme.heading3,
            ),
            SizedBox(height: 8),
            Text(
              'Các chuyến đi của bạn sẽ hiển thị ở đây',
              style: AppTheme.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
