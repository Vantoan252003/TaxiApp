import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';

class NewsItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String timeAgo;
  final bool isPromotion;

  const NewsItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.timeAgo,
    this.isPromotion = false,
  });
}

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final newsItems = [
      const NewsItem(
        title: 'Cập nhật ứng dụng mới',
        subtitle: 'Trải nghiệm đặt xe tốt hơn với giao diện mới',
        imageUrl: 'assets/images/banner.png',
        timeAgo: '2 giờ trước',
      ),
      const NewsItem(
        title: 'Khuyến mãi cuối tuần',
        subtitle: 'Giảm 30% cho tất cả chuyến xe trong ngày',
        imageUrl: 'assets/images/banner.png',
        timeAgo: '1 ngày trước',
        isPromotion: true,
      ),
      const NewsItem(
        title: 'Tính năng mới: Đặt xe theo lịch',
        subtitle: 'Đặt xe trước và không lo bị trễ',
        imageUrl: 'assets/images/banner.png',
        timeAgo: '3 ngày trước',
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
                'Tin tức & Khuyến mãi',
                style: AppTheme.heading3,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to news screen
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsItems.length,
          itemBuilder: (context, index) {
            final news = newsItems[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: AppTheme.subtleCardDecoration,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(news.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: news.isPromotion
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.warningRed.withOpacity(0.8),
                          ),
                          child: const Center(
                            child: Text(
                              'KM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                title: Text(
                  news.title,
                  style: AppTheme.body2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      news.subtitle,
                      style: AppTheme.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.timeAgo,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.lightGray,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.lightGray,
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to news detail
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
