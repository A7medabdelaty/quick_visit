class PatientDetails {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String relation;
  final String? phoneNumber;
  final String? email;

  const PatientDetails({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.relation,
    this.phoneNumber,
    this.email,
  });

  factory PatientDetails.fromMap(Map<String, dynamic> map) {
    return PatientDetails(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      relation: map['relation'] ?? '',
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'relation': relation,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  String get fullName => '$firstName $lastName';
}
