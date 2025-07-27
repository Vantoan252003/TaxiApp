import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/constants/app_constants.dart';
import '../../general_lib/core/providers/auth_provider.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final userName = user?.displayName ?? AppConstants.defaultUserName;

        return SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Banner image at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlack.withOpacity(0.3),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Color(0x40000000),
                        BlendMode.overlay,
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top padding
                    // Greeting text
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Hi, ',
                          style: AppTheme.heading2.copyWith(
                            color: AppTheme.primaryWhite,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          userName,
                          style: AppTheme.heading2.copyWith(
                            color: AppTheme.yellowOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 30), // Space for location section overlap
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
