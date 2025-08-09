import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class AppHeaderSection extends StatelessWidget {
  const AppHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding / 6),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/city.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.defaultRadius),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        size: 80,
                        color: AppTheme.lightGray,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              //dịch sang tiếng Việt
              'Mozi',
              style: AppTheme.heading1.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ứng dụng đặt taxi nhanh chóng và tiện lợi',
              style: AppTheme.body1.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
