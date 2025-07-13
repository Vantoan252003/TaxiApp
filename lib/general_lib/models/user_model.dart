class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String phoneNumber;
  final DateTime createdAt;
  final String? photoURL;
  final String? role;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.phoneNumber,
    required this.createdAt,
    this.photoURL,
    required this.role,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'photoURL': photoURL,
      'role': role,
    };
  }

  // Create from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      photoURL: map['photoURL'],
      role: map['role'] ?? 'user', //mặc định vai trò là người dùng
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(json);
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? phoneNumber,
    DateTime? createdAt,
    String? photoURL,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, firstName: $firstName, phoneNumber: $phoneNumber, role: $role)';
  }
}
