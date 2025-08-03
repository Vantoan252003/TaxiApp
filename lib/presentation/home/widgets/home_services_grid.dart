import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/search/screen/destination_selection_screen.dart';
import '../../../core/services/service_config.dart';
import '../../../core/constants/app_theme.dart';

class HomeServicesGrid extends StatelessWidget {
  final Function(String) onServiceTap;

  const HomeServicesGrid({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = ServiceFactory.getServices();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DestinationSelectionScreen(),
                  ),
                ),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlack.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          service.icon,
                          color: AppTheme.primaryBlack,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.title,
                        style: AppTheme.caption,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
