class UserModel {
  final String userId;
  final String email;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? avatarUrl;
  final String? dateOfBirth;
  final bool? isVerified;
  final bool? isActive;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final List<String>? roles;
  final String? userType;

  UserModel({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.fullName,
    this.avatarUrl,
    this.dateOfBirth,
    this.isVerified,
    this.isActive,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.roles,
    this.userType,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth,
      'isVerified': isVerified,
      'isActive': isActive,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'roles': roles,
      'userType': userType,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      fullName: json['fullName'] ?? json['full_name'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      dateOfBirth: json['dateOfBirth'] ?? json['date_of_birth'],
      isVerified: json['isVerified'] ?? json['is_verified'],
      isActive: json['isActive'] ?? json['is_active'],
      accessToken: json['accessToken'] ?? json['token'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
      expiresIn: json['expiresIn'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      userType: json['userType'],
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? userId,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatarUrl,
    String? dateOfBirth,
    bool? isVerified,
    bool? isActive,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    List<String>? roles,
    String? userType,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      roles: roles ?? this.roles,
      userType: userType ?? this.userType,
    );
  }

  // Get display name (fullName > firstName + lastName > email > phoneNumber)
  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!;
    }

    if (firstName != null &&
        lastName != null &&
        firstName!.isNotEmpty &&
        lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }

    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }

    if (lastName != null && lastName!.isNotEmpty) {
      return lastName!;
    }

    if (email.isNotEmpty) {
      return email;
    }

    return phoneNumber;
  }

  // Get initials for avatar
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.trim().split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }

    if (firstName != null &&
        lastName != null &&
        firstName!.isNotEmpty &&
        lastName!.isNotEmpty) {
      // Xử lý trường hợp firstName có thể có nhiều từ
      final firstNames = firstName!.trim().split(' ');
      final firstInitial = firstNames[0][0];
      final lastInitial = lastName![0];
      return '$firstInitial$lastInitial'.toUpperCase();
    }

    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }

    if (lastName != null && lastName!.isNotEmpty) {
      return lastName![0].toUpperCase();
    }

    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }

    return 'U';
  }

  // Get formatted date of birth
  String? get formattedDateOfBirth {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) return null;
    try {
      final date = DateTime.parse(dateOfBirth!);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateOfBirth;
    }
  }

  // Get age from date of birth
  int? get age {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) return null;
    try {
      final birthDate = DateTime.parse(dateOfBirth!);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, phoneNumber: $phoneNumber, fullName: $fullName, userType: $userType)';
  }
}
