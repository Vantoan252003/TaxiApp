import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? subtitle;

  MenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.subtitle,
  });
}

class UserProfile {
  final String name;
  final String rating;
  final String badge;
  final String? profileImage;

  UserProfile({
    required this.name,
    required this.rating,
    required this.badge,
    this.profileImage,
  });
}
