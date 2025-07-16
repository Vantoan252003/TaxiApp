import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/constants/app_constants.dart';

class HomeSuggestionSection extends StatelessWidget {
  const HomeSuggestionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gợi ý cho bạn',
            style: AppTheme.heading3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlack,
                  AppTheme.darkGray,
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlack.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ĐẶT TRƯỚC CHUYẾN ĐI XA',
                          style: AppTheme.heading3.copyWith(
                            color: AppTheme.primaryWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'GIÁ SIÊU RẺ',
                          style: AppTheme.heading2.copyWith(
                            color: const Color(0xFFDDC7A0), // Màu kem vàng nhẹ
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Taxi Hà Tình',
                          style: AppTheme.body1.copyWith(
                            color: AppTheme.primaryWhite.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Illustration space
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryWhite.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: AppTheme.primaryWhite,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
