import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class PromotionItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color backgroundColor;
  final String discountText;

  const PromotionItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.backgroundColor,
    required this.discountText,
  });
}

class HomePromotionCarousel extends StatefulWidget {
  const HomePromotionCarousel({super.key});

  @override
  State<HomePromotionCarousel> createState() => _HomePromotionCarouselState();
}

class _HomePromotionCarouselState extends State<HomePromotionCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<PromotionItem> _promotions = [
    const PromotionItem(
      title: 'Giảm 20%',
      subtitle: 'Cho chuyến xe đầu tiên',
      imageUrl: 'assets/images/banner.png',
      backgroundColor: Color(0xFFFF6B6B),
      discountText: '20%',
    ),
    const PromotionItem(
      title: 'Miễn phí vận chuyển',
      subtitle: 'Đơn hàng trên 50k',
      imageUrl: 'assets/images/banner.png',
      backgroundColor: Color(0xFF4ECDC4),
      discountText: 'FREE',
    ),
    const PromotionItem(
      title: 'Ưu đãi đặc biệt',
      subtitle: 'Cho khách hàng VIP',
      imageUrl: 'assets/images/banner.png',
      backgroundColor: Color(0xFF45B7D1),
      discountText: 'VIP',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentIndex < _promotions.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        }
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promotion = _promotions[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      promotion.backgroundColor,
                      promotion.backgroundColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: promotion.backgroundColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background image
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  promotion.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  promotion.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  promotion.discountText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _promotions.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppTheme.primaryBlack
                    : Colors.grey.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
