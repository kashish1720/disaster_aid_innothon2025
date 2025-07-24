class AidRequest {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String requestType;
  final String description;
  final String timestamp;
  final String status;
  final List<String> imagePaths;

  AidRequest({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.requestType,
    required this.description,
    required this.timestamp,
    required this.status,
    required this.imagePaths,
  });

  // Convert request to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'requestType': requestType,
      'description': description,
      'timestamp': timestamp,
      'status': status,
      'imagePaths': imagePaths,
    };
  }

  // Create request from JSON
  factory AidRequest.fromJson(Map<String, dynamic> json) {
    return AidRequest(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'] ?? '',
      address: json['address'],
      requestType: json['requestType'],
      description: json['description'],
      timestamp: json['timestamp'],
      status: json['status'],
      imagePaths: json['imagePaths'] != null 
          ? List<String>.from(json['imagePaths'])
          : [],
    );
  }
}