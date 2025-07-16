class RegistrationRequest {
  final String email;
  final String phone;
  final String password;
  final String firstName;
  final String lastName;

  RegistrationRequest({
    required this.email,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
