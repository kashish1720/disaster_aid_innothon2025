class AppUser {
  final String id;
  final String name;
  final String email;
  final String organization;
  final String phone;
  final String userType;
  final String password; // In a real app, this should be hashed

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.organization,
    required this.phone,
    required this.userType,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'organization': organization,
      'phone': phone,
      'userType': userType,
      'password': password, // Note: in a real app, never store plain text passwords
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      organization: json['organization'],
      phone: json['phone'],
      userType: json['userType'],
      password: json['password'],
    );
  }
}