import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../data/models/user_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditing = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _selectedDate = user?.formattedDateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: AppTheme.primaryWhite,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Avatar Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: _showAvatarOptions,
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.borderColor,
                                  width: 3,
                                ),
                              ),
                              child: user?.avatarUrl != null &&
                                      user!.avatarUrl!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        user.avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildDefaultAvatar(user);
                                        },
                                      ),
                                    )
                                  : _buildDefaultAvatar(user),
                            ),
                            // Camera icon overlay
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.accentBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primaryWhite,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: AppTheme.primaryWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        user?.displayName ?? 'Người dùng',
                        style: AppTheme.heading2,
                        textAlign: TextAlign.center,
                      ),

                      if (user?.age != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${user!.age} tuổi',
                          style: AppTheme.body2.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],

                      // Verification Status
                      if (user?.isVerified == true) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
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

                const SizedBox(height: 24),

                // Personal Information Form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Thông tin cá nhân',
                        style: AppTheme.heading3,
                      ),
                      const SizedBox(height: 20),

                      // First Name
                      _buildInfoField(
                        label: 'Họ',
                        controller: _firstNameController,
                        icon: Icons.person_outline,
                        enabled: _isEditing,
                      ),

                      const SizedBox(height: 16),

                      // Last Name
                      _buildInfoField(
                        label: 'Tên',
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        enabled: _isEditing,
                      ),

                      const SizedBox(height: 16),

                      // Email
                      _buildInfoField(
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        enabled: _isEditing, // Email không được chỉnh sửa
                      ),

                      const SizedBox(height: 16),

                      // Phone Number
                      _buildInfoField(
                        label: 'Số điện thoại',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        enabled: false, // Phone không được chỉnh sửa
                      ),

                      const SizedBox(height: 16),

                      // Date of Birth
                      _buildDateField(
                        label: 'Ngày sinh',
                        value: _selectedDate,
                        enabled: _isEditing,
                        onTap: _isEditing ? _selectDate : null,
                      ),

                      // Action Buttons
                      if (_isEditing) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelEdit,
                                style: AppTheme.secondaryButtonStyle,
                                child: const Text('Hủy'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: AppTheme.primaryButtonStyle,
                                child: const Text('Lưu'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            style: AppTheme.primaryButtonStyle,
                            child: const Text('Chỉnh sửa'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: AppTheme.inputDecoration.copyWith(
            prefixIcon: Icon(icon, color: AppTheme.mediumGray),
            hintText: label,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String? value,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: enabled
                  ? AppTheme.backgroundColor
                  : AppTheme.backgroundColor.withOpacity(0.5),
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    color: AppTheme.mediumGray),
                const SizedBox(width: 12),
                Text(
                  value ?? 'Chọn ngày sinh',
                  style: AppTheme.body2.copyWith(
                    color:
                        value != null ? AppTheme.darkGray : AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(UserModel? user) {
    if (user != null && user.initials.isNotEmpty) {
      return Center(
        child: Text(
          user.initials,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
      );
    }

    return const Icon(
      Icons.person,
      size: 50,
      color: AppTheme.mediumGray,
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _initializeControllers(); // Reset to original values
    });
  }

  Future<void> _saveChanges() async {
    // Validate required fields
    if (_firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập họ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày sinh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert date format from DD/MM/YYYY to YYYY-MM-DD
    final dateParts = _selectedDate!.split('/');
    final formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updatePersonalInfo(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: formattedDate,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thông tin đã được cập nhật thành công'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        setState(() {
          _isEditing = false;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                authProvider.errorMessage ?? 'Cập nhật thông tin thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Chọn ảnh đại diện',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: 24),

            // Options
            _buildAvatarOption(
              icon: Icons.photo_library_outlined,
              title: 'Chọn từ thư viện ảnh',
              subtitle: 'Chọn ảnh có sẵn từ thiết bị',
              onTap: () {
                Navigator.pop(context);
                _selectFromGallery();
              },
            ),

            const SizedBox(height: 16),

            _buildAvatarOption(
              icon: Icons.camera_alt_outlined,
              title: 'Chụp ảnh mới',
              subtitle: 'Chụp ảnh bằng camera',
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),

            const SizedBox(height: 24),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: AppTheme.secondaryButtonStyle,
                child: const Text('Hủy'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.accentBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.body2.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.mediumGray,
            ),
          ],
        ),
      ),
    );
  }

  void _selectFromGallery() {
    // TODO: Implement image picker from gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chọn từ thư viện ảnh đang được phát triển'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  void _takePhoto() {
    // TODO: Implement camera functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chụp ảnh đang được phát triển'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }
}
