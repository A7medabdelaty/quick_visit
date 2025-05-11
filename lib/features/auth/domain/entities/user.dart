class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  String? profileImage;
  List<String>? medicalHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.profileImage,
    this.medicalHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'profileImage': profileImage,
      'medicalHistory': medicalHistory,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['createdAt']),
      profileImage: map['profileImage'],
      medicalHistory: List<String>.from(map['medicalHistory']),
    );
  }
}
