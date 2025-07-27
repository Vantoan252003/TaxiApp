import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/core/providers/auth_provider.dart';
import '../../general_lib/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

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
                    child:
                        user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  user.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar(user);
                                  },
                                ),
                              )
                            : _buildDefaultAvatar(user),
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

                  // User Age (if available)
                  if (user?.age != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${user!.age} tuổi',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  // Verification Status
                  if (user?.isVerified == true) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: AppTheme.successGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Đã xác thực',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar(UserModel? user) {
    if (user != null && user.initials.isNotEmpty) {
      return Center(
        child: Text(
          user.initials,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
      );
    }

    return const Icon(
      Icons.person,
      size: 40,
      color: AppTheme.mediumGray,
    );
  }
}
