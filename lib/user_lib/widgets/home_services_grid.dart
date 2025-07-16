import 'package:flutter/material.dart';
import '../../general_lib/services/service_config.dart';
import 'home_service_item.dart';

class HomeServicesGrid extends StatelessWidget {
  final Function(String) onServiceTap;

  const HomeServicesGrid({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = ServiceFactory.getServices();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return HomeServiceItem(
          icon: service.icon,
          title: service.title,
          onTap: () => onServiceTap(service.type),
        );
      },
    );
  }
}
