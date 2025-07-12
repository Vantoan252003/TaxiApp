import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        elevation: 0,
        title: const Text(
          'Taxi App',
          style: AppTheme.heading3,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_taxi,
              size: 80,
              color: AppTheme.accentBlue,
            ),
            SizedBox(height: 24),
            Text(
              'Chào mừng đến với Taxi App!',
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Chuyến đi của bạn chỉ cách một cú chạm',
              style: AppTheme.body1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Add ride booking interface here later
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 40,
                        color: Color(0xFF007AFF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Book Your Ride',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Coming soon...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
