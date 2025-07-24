class Volunteer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String skills;
  final String availability;
  final String status;
  final String organization;
  final DateTime registrationDate;

  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.skills,
    required this.availability,
    required this.status,
    required this.organization,
    required this.registrationDate,
  });

  factory Volunteer.fromMap(Map<String, dynamic> map) {
    return Volunteer(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      skills: map['skills'] ?? '',
      availability: map['availability'] ?? '',
      status: map['status'] ?? 'active',
      organization: map['organization'] ?? '',
      registrationDate: map['registrationDate'] != null 
          ? DateTime.parse(map['registrationDate']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'skills': skills,
      'availability': availability,
      'status': status,
      'organization': organization,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
}