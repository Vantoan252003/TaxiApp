import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class PopularPlace {
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const PopularPlace({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });
}

class HomePopularPlaces extends StatelessWidget {
  const HomePopularPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final popularPlaces = [
      const PopularPlace(
        name: 'Trung tâm thương mại',
        address: 'Quận 1, TP.HCM',
        imageUrl: 'assets/images/city.png',
        rating: 4.5,
        reviewCount: 128,
      ),
      const PopularPlace(
        name: 'Sân bay Tân Sơn Nhất',
        address: 'Quận Tân Bình, TP.HCM',
        imageUrl: 'assets/images/city.png',
        rating: 4.3,
        reviewCount: 89,
      ),
      const PopularPlace(
        name: 'Bệnh viện Chợ Rẫy',
        address: 'Quận 5, TP.HCM',
        imageUrl: 'assets/images/city.png',
        rating: 4.7,
        reviewCount: 156,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Địa điểm phổ biến',
                style: AppTheme.heading3,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to popular places screen
                },
                child: Text(
                  'Xem tất cả',
                  style: AppTheme.body2.copyWith(
                    color: AppTheme.accentBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularPlaces.length,
            itemBuilder: (context, index) {
              final place = popularPlaces[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                decoration: AppTheme.subtleCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.asset(
                        place.imageUrl,
                        height: 60,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: AppTheme.body2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            place.address,
                            style: AppTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppTheme.yellowOrange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${place.rating}',
                                style: AppTheme.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${place.reviewCount})',
                                style: AppTheme.caption,
                              ),
                            ],
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
      ],
    );
  }
}
