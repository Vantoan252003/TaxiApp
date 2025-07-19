class UserModel {
  final String userId;
  final String email;
  final String phoneNumber;
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
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      roles: roles ?? this.roles,
      userType: userType ?? this.userType,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, phoneNumber: $phoneNumber, userType: $userType)';
  }
}
