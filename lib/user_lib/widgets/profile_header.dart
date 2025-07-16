import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../general_lib/constants/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderColor,
                    width: 2,
                  ),
                ),
                child: user?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          user!.photoURL!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        ),
                      )
                    : _buildDefaultAvatar(),
              ),

              const SizedBox(height: 16),

              // User Name
              Text(
                user?.displayName ?? 'Người dùng',
                style: AppTheme.heading3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // User Email
              Text(
                user?.email ?? '',
                style: AppTheme.body2.copyWith(
                  color: AppTheme.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 40,
      color: AppTheme.mediumGray,
    );
  }



}
