import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/home_banner_section.dart';
import '../widgets/home_location_section.dart';
import '../widgets/home_services_grid.dart';
import '../widgets/home_suggestion_section.dart';
import '../widgets/home_promotion_carousel.dart';
import '../widgets/home_popular_places.dart';
import '../widgets/home_news_section.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Load user info từ API khi vào màn hình
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showFeatureInDevelopment(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature ${AppConstants.featureInDevelopment}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  // Banner Section with banner.png
                  const HomeBannerSection(),

                  // Location Input Section
                  const HomeLocationSection(),

                  // Main Content
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Services Grid - Đặt lên đầu để dễ đặt xe
                            HomeServicesGrid(
                              onServiceTap: (serviceType) =>
                                  _showFeatureInDevelopment(
                                      'Dịch vụ $serviceType'),
                            ),
                            const SizedBox(height: 20),

                            // Promotion Carousel
                            const HomePromotionCarousel(),
                            const SizedBox(height: 20),

                            // Stats Section - Thông tin chuyến xe, tích điểm, tiết kiệm

                            // Popular Places
                            const HomePopularPlaces(),
                            const SizedBox(height: 20),

                            // News Section
                            const HomeNewsSection(),
                            const SizedBox(height: 20),

                            // Suggestion Section
                            const HomeSuggestionSection(),
                            const SizedBox(
                                height:
                                    20), // Thêm padding cuối để tránh overflow
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
