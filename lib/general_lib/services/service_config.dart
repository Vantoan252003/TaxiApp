import 'package:flutter/material.dart';

class ServiceConfig {
  final IconData icon;
  final String title;
  final String type;

  const ServiceConfig({
    required this.icon,
    required this.title,
    required this.type,
  });
}

class ServiceFactory {
  static const List<ServiceConfig> _services = [
    ServiceConfig(
      icon: Icons.motorcycle,
      title: 'Đặt xe máy',
      type: 'motorcycle',
    ),
    ServiceConfig(
      icon: Icons.directions_car,
      title: 'Xe taxi',
      type: 'taxi',
    ),
    ServiceConfig(
      icon: Icons.electric_car,
      title: 'Xe điện',
      type: 'electric',
    ),
    ServiceConfig(
      icon: Icons.delivery_dining,
      title: 'Giao hàng',
      type: 'delivery',
    ),
  ];

  static List<ServiceConfig> getServices() => _services;
}
